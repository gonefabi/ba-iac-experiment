##############################################################################
# network.tf – Virtuelles Netzwerk, Subnetze und Sicherheitsgruppen (NSGs)
##############################################################################

# ---------------------------------------------------------------------------
# Virtuelles Netzwerk
# ---------------------------------------------------------------------------
resource "azurerm_virtual_network" "main" {
  name                = "vnet-unternehmen"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space

  tags = azurerm_resource_group.main.tags
}

# ---------------------------------------------------------------------------
# Subnetz: Benutzer (10.0.1.0/24)
# ---------------------------------------------------------------------------
resource "azurerm_subnet" "users" {
  name                 = "snet-benutzer"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_users_prefix
}

# ---------------------------------------------------------------------------
# Subnetz: Anwendung (10.0.2.0/24)
# ---------------------------------------------------------------------------
resource "azurerm_subnet" "app" {
  name                 = "snet-anwendung"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_app_prefix
}

# ╔═════════════════════════════════════════════════════════════════════════╗
# ║  NSG: Benutzer-Subnetz                                                ║
# ╚═════════════════════════════════════════════════════════════════════════╝
resource "azurerm_network_security_group" "users" {
  name                = "nsg-benutzer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # --- Eingehend -----------------------------------------------------------

  # RDP von der erlaubten Quell-IP (Standard: Büro-IP)
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

  # ICMP (Ping) aus dem gesamten VNet erlauben – hilfreich für Diagnose
  security_rule {
    name                       = "Allow-ICMP-VNet"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_subnet_network_security_group_association" "users" {
  subnet_id                 = azurerm_subnet.users.id
  network_security_group_id = azurerm_network_security_group.users.id
}

# ╔═════════════════════════════════════════════════════════════════════════╗
# ║  NSG: Anwendungs-Subnetz                                              ║
# ╚═════════════════════════════════════════════════════════════════════════╝
resource "azurerm_network_security_group" "app" {
  name                = "nsg-anwendung"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # --- Eingehend -----------------------------------------------------------

  # SSH nur aus dem VNet (interner Zugriff)
  security_rule {
    name                       = "Allow-SSH-VNet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # HTTP/HTTPS nur aus dem VNet
  security_rule {
    name                       = "Allow-HTTP-VNet"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # ICMP (Ping) aus dem VNet
  security_rule {
    name                       = "Allow-ICMP-VNet"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  # Alles andere eingehend aus dem Internet blockieren
  security_rule {
    name                       = "Deny-All-Internet-Inbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # --- Ausgehend -----------------------------------------------------------

  # Internetzugang blockieren (kein direkter Ausgang)
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

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}
