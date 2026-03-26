###############################################################################
# Azure-Infrastruktur – Kleines Unternehmen (20 Mitarbeiter)
# 
# Komponenten:
#   - Ressourcengruppe (Germany West Central)
#   - VNet mit Benutzer- und Anwendungs-Subnetz
#   - Windows-VM (RDP-Zugang) im Benutzer-Subnetz
#   - Linux-VM (nur intern erreichbar) im Anwendungs-Subnetz
#   - Network Security Groups mit passenden Regeln
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

resource "azurerm_subnet" "users" {
  name                 = "snet-users"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_users_prefix]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_app_prefix]
}

# =============================================================================
# Network Security Groups
# =============================================================================

# --- Benutzer-Subnetz (erlaubt RDP von außen) --------------------------------

resource "azurerm_network_security_group" "users" {
  name                = "${var.prefix}-nsg-users"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # RDP-Zugang – im Produktivbetrieb unbedingt auf bekannte IPs einschränken!
  security_rule {
    name                       = "Allow-RDP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.allowed_rdp_source_ip
    destination_address_prefix = "*"
  }

  # Interne Kommunikation zum App-Subnetz erlauben
  security_rule {
    name                       = "Allow-VNet-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.subnet_users_prefix
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "users" {
  subnet_id                 = azurerm_subnet.users.id
  network_security_group_id = azurerm_network_security_group.users.id
}

# --- Anwendungs-Subnetz (nur interner Zugriff, kein Internet) ----------------

resource "azurerm_network_security_group" "app" {
  name                = "${var.prefix}-nsg-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Eingehend: nur Verkehr aus dem VNet erlauben
  security_rule {
    name                       = "Allow-VNet-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-Internet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Ausgehend: nur VNet-Verkehr erlauben, Internet blockieren
  security_rule {
    name                       = "Allow-VNet-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Deny-Internet-Outbound"
    priority                   = 200
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

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
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
    subnet_id                     = azurerm_subnet.users.id
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
  admin_username        = var.windows_admin_username
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
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
    # Keine öffentliche IP – nur intern erreichbar
  }

  tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm-linux"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = var.linux_vm_size
  admin_username                  = var.linux_admin_username
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
