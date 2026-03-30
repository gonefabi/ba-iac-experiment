##############################################################################
# main.tf – BA-IaC-Experiment / Azure-Infrastruktur
# Provider: AzureRM >= 4.0 | Region: germanywestcentral
##############################################################################

# ── Provider ────────────────────────────────────────────────────────────────

terraform {
  required_version = ">= 1.5"

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

# ── Locals ──────────────────────────────────────────────────────────────────

locals {
  location = "germanywestcentral"

  tags = {
    Environment = "Development"
    Owner       = "Fabian Klein"
    Project     = "BA-IaC-Experiment"
  }

  admin_username = "kmuadmin"
}

# ── Bestehende Ressourcengruppe (Data Source – wird NICHT verwaltet) ────────

data "azurerm_resource_group" "main" {
  name = "rg-kmu-experiment"
}

# ═══════════════════════════════════════════════════════════════════════════
# NETZWERK
# ═══════════════════════════════════════════════════════════════════════════

# ── Virtual Network ─────────────────────────────────────────────────────────

resource "azurerm_virtual_network" "main" {
  name                = "vnet-kmu-main"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  tags = local.tags
}

# ── Subnets ─────────────────────────────────────────────────────────────────

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

# ═══════════════════════════════════════════════════════════════════════════
# NETWORK SECURITY GROUPS
# ═══════════════════════════════════════════════════════════════════════════

# ── NSG: nsg-user ───────────────────────────────────────────────────────────

resource "azurerm_network_security_group" "user" {
  name                = "nsg-user"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name

  # Inbound – RDP erlauben von admin_source_ip
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

  # Inbound – Alles andere verweigern
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

  # Outbound – Alles erlauben
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

  tags = local.tags
}

# ── NSG: nsg-app ────────────────────────────────────────────────────────────

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name

  # Inbound – SSH aus snet-user
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

  # Inbound – HTTP aus snet-user
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

  # Inbound – Alles andere verweigern
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

  # Outbound – Alles erlauben
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

  tags = local.tags
}

# ── NSG ↔ Subnet-Zuordnungen (auf Subnetz-Ebene, NICHT auf NIC) ───────────

resource "azurerm_subnet_network_security_group_association" "user" {
  subnet_id                 = azurerm_subnet.user.id
  network_security_group_id = azurerm_network_security_group.user.id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

# ═══════════════════════════════════════════════════════════════════════════
# PUBLIC IP
# ═══════════════════════════════════════════════════════════════════════════

resource "azurerm_public_ip" "jumpbox" {
  name                = "pip-vm-kmu-jumpbox"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = local.tags
}

# ═══════════════════════════════════════════════════════════════════════════
# NETWORK INTERFACES
# ═══════════════════════════════════════════════════════════════════════════

resource "azurerm_network_interface" "jumpbox" {
  name                = "nic-vm-kmu-jumpbox"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.user.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox.id
  }

  tags = local.tags
}

resource "azurerm_network_interface" "app" {
  name                = "nic-vm-kmu-app"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

# ═══════════════════════════════════════════════════════════════════════════
# VIRTUAL MACHINES
# ═══════════════════════════════════════════════════════════════════════════

# ── Windows VM (Jumpbox) ────────────────────────────────────────────────────

resource "azurerm_windows_virtual_machine" "jumpbox" {
  name                = "vm-kmu-jumpbox"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = "Standard_D2as_v4"
  zone                = "1"

  admin_username = local.admin_username
  admin_password = var.windows_admin_password

  network_interface_ids = [
    azurerm_network_interface.jumpbox.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  tags = local.tags
}

# ── Linux VM (App-Server) ──────────────────────────────────────────────────

resource "azurerm_linux_virtual_machine" "app" {
  name                = "vm-kmu-app"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  size                = "Standard_D2as_v4"
  zone                = "1"

  admin_username                  = local.admin_username
  admin_password                  = var.linux_admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.app.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.tags
}
