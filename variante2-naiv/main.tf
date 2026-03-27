###############################################################################
# Azure-Infrastruktur – Kleines Unternehmen (20 Mitarbeiter)
# 
# Komponenten:
#   - Ressourcengruppe (Germany West Central)
#   - VNet mit Benutzer- und Anwendungs-Subnetz
#   - Windows-VM (RDP-Zugang) im Benutzer-Subnetz
#   - Linux-VM (nur intern erreichbar) im Anwendungs-Subnetz
#   - NSGs mit passenden Firewall-Regeln
#   - Route Table zum Blockieren des Internetzugangs für die Linux-VM
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

# =============================================================================
# Ressourcengruppe
# =============================================================================

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = var.common_tags
}

# =============================================================================
# Virtuelles Netzwerk + Subnetze
# =============================================================================

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet_address_space]

  tags = var.common_tags
}

resource "azurerm_subnet" "benutzer" {
  name                 = "snet-benutzer"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_benutzer_prefix]
}

resource "azurerm_subnet" "anwendung" {
  name                 = "snet-anwendung"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_anwendung_prefix]
}

# =============================================================================
# Network Security Groups (Firewall-Regeln)
# =============================================================================

# --- Benutzer-Subnetz: RDP von außen erlaubt ---------------------------------

resource "azurerm_network_security_group" "benutzer" {
  name                = "${var.prefix}-nsg-benutzer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # RDP-Zugriff nur von deiner Admin-IP
  security_rule {
    name                       = "Allow-RDP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.admin_source_ip
    destination_address_prefix = "*"
  }

  # Kommunikation aus dem Anwendungs-Subnetz erlauben
  security_rule {
    name                       = "Allow-App-Subnet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_anwendung_prefix
    destination_address_prefix = "*"
  }

  # Alles andere eingehend blockieren
  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.common_tags
}

# --- Anwendungs-Subnetz: nur interner Verkehr --------------------------------

resource "azurerm_network_security_group" "anwendung" {
  name                = "${var.prefix}-nsg-anwendung"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # SSH nur aus dem Benutzer-Subnetz
  security_rule {
    name                       = "Allow-SSH-From-User-Subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.subnet_benutzer_prefix
    destination_address_prefix = "*"
  }

  # HTTP/HTTPS aus dem Benutzer-Subnetz (für Anwendungen)
  security_rule {
    name                       = "Allow-HTTP-From-User-Subnet"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = var.subnet_benutzer_prefix
    destination_address_prefix = "*"
  }

  # Gesamten eingehenden Verkehr von außen blockieren
  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Internet-Ausgang blockieren
  security_rule {
    name                       = "Deny-Internet-Outbound"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = var.common_tags
}

# NSGs den Subnetzen zuweisen
resource "azurerm_subnet_network_security_group_association" "benutzer" {
  subnet_id                 = azurerm_subnet.benutzer.id
  network_security_group_id = azurerm_network_security_group.benutzer.id
}

resource "azurerm_subnet_network_security_group_association" "anwendung" {
  subnet_id                 = azurerm_subnet.anwendung.id
  network_security_group_id = azurerm_network_security_group.anwendung.id
}

# =============================================================================
# Route Table – Internetzugang für Anwendungs-Subnetz blockieren
# =============================================================================

resource "azurerm_route_table" "anwendung" {
  name                = "${var.prefix}-rt-anwendung"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name                   = "block-internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "None"
  }

  tags = var.common_tags
}

resource "azurerm_subnet_route_table_association" "anwendung" {
  subnet_id      = azurerm_subnet.anwendung.id
  route_table_id = azurerm_route_table.anwendung.id
}

# =============================================================================
# Windows-VM (Benutzer-Subnetz) – RDP-Zugang
# =============================================================================

resource "azurerm_public_ip" "windows" {
  name                = "${var.prefix}-pip-win"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.common_tags
}

resource "azurerm_network_interface" "windows" {
  name                = "${var.prefix}-nic-win"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.benutzer.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows.id
  }

  tags = var.common_tags
}

resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${var.prefix}-vm-win"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  size                  = var.windows_vm_size
  admin_username        = var.windows_admin_user
  admin_password        = var.windows_admin_password
  network_interface_ids = [azurerm_network_interface.windows.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = var.common_tags
}

# =============================================================================
# Linux-VM (Anwendungs-Subnetz) – nur intern erreichbar
# =============================================================================

resource "azurerm_network_interface" "linux" {
  name                = "${var.prefix}-nic-linux"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.anwendung.id
    private_ip_address_allocation = "Dynamic"
    # Kein public_ip_address_id → kein Internetzugang
  }

  tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm-linux"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = var.linux_vm_size
  admin_username                  = var.linux_admin_user
  disable_password_authentication = false
  admin_password                  = var.linux_admin_password
  network_interface_ids           = [azurerm_network_interface.linux.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.common_tags
}
