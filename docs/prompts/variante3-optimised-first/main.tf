# ============================================================================
# main.tf – KMU-IaC-Experiment / Azure-Infrastruktur
# Provider, Data Sources und sämtliche Ressourcen
# ============================================================================

# ----------------------------------------------------------------------------
# Terraform-Block & Provider
# ----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ----------------------------------------------------------------------------
# Lokale Werte – zentrale Tag-Definition (DRY)
# ----------------------------------------------------------------------------

locals {
  location = "germanywestcentral"

  mandatory_tags = {
    Environment = "Development"
    Owner       = "Fabian Klein"
    Project     = "BA-IaC-Experiment"
  }
}

# ----------------------------------------------------------------------------
# Data Source – bestehende Ressourcengruppe (NICHT von Terraform verwaltet)
# ----------------------------------------------------------------------------

data "azurerm_resource_group" "main" {
  name = "rg-kmu-experiment"
}

# ============================================================================
# NETZWERK
# ============================================================================

# ----------------------------------------------------------------------------
# Virtual Network
# ----------------------------------------------------------------------------

resource "azurerm_virtual_network" "main" {
  name                = "vnet-kmu-main"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  tags = local.mandatory_tags
}

# ----------------------------------------------------------------------------
# Subnetze
# ----------------------------------------------------------------------------

resource "azurerm_subnet" "user" {
  name                 = "snet-user"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# ============================================================================
# NETWORK SECURITY GROUPS
# ============================================================================

# ----------------------------------------------------------------------------
# NSG – snet-user  (RDP-Zugang für Jumpbox)
# ----------------------------------------------------------------------------

resource "azurerm_network_security_group" "user" {
  name                = "nsg-user"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name

  # --- Inbound: RDP von Admin-IP erlauben ---
  security_rule {
    name                       = "Allow-RDP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.admin_source_ip}/32"
    destination_address_prefix = "*"
  }

  # --- Inbound: alles andere verbieten ---
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

  # --- Outbound: alles erlauben ---
  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.mandatory_tags
}

# ----------------------------------------------------------------------------
# NSG – snet-app  (SSH + HTTP nur aus snet-user)
# ----------------------------------------------------------------------------

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name

  # --- Inbound: SSH aus snet-user ---
  security_rule {
    name                       = "Allow-SSH-From-User-Subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  # --- Inbound: HTTP aus snet-user ---
  security_rule {
    name                       = "Allow-HTTP-From-User-Subnet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  # --- Inbound: alles andere verbieten ---
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

  # --- Outbound: alles erlauben ---
  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.mandatory_tags
}

# ----------------------------------------------------------------------------
# NSG ↔ Subnetz-Zuordnungen (Subnetz-Ebene, NICHT NIC-Ebene)
# ----------------------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "user" {
  subnet_id                 = azurerm_subnet.user.id
  network_security_group_id = azurerm_network_security_group.user.id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

# ============================================================================
# PUBLIC IP
# ============================================================================

resource "azurerm_public_ip" "jumpbox" {
  name                = "pip-vm-kmu-jumpbox"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = local.mandatory_tags
}

# ============================================================================
# NETZWERK-INTERFACES
# ============================================================================

# ----------------------------------------------------------------------------
# NIC – Windows Jumpbox (mit Public IP)
# ----------------------------------------------------------------------------

resource "azurerm_network_interface" "jumpbox" {
  name                = "nic-vm-kmu-jumpbox"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig-jumpbox"
    subnet_id                     = azurerm_subnet.user.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox.id
  }

  tags = local.mandatory_tags
}

# ----------------------------------------------------------------------------
# NIC – Linux App VM (ohne Public IP)
# ----------------------------------------------------------------------------

resource "azurerm_network_interface" "app" {
  name                = "nic-vm-kmu-app"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig-app"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.mandatory_tags
}

# ============================================================================
# VIRTUELLE MASCHINEN
# ============================================================================

# ----------------------------------------------------------------------------
# Windows VM – Jumpbox (RDP-Zugang)
# ----------------------------------------------------------------------------

resource "azurerm_windows_virtual_machine" "jumpbox" {
  name                = "vm-kmu-jumpbox"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = "Standard_D2as_v4"
  zone                = "1"

  admin_username = "kmuadmin"
  admin_password = var.windows_admin_password

  network_interface_ids = [
    azurerm_network_interface.jumpbox.id,
  ]

  os_disk {
    name                 = "osdisk-vm-kmu-jumpbox"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  tags = local.mandatory_tags
}

# ----------------------------------------------------------------------------
# Linux VM – App-Server (nur intern erreichbar)
# ----------------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "app" {
  name                = "vm-kmu-app"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = "Standard_D2as_v4"
  zone                = "1"

  admin_username                  = "kmuadmin"
  admin_password                  = var.linux_admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.app.id,
  ]

  os_disk {
    name                 = "osdisk-vm-kmu-app"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.mandatory_tags
}
