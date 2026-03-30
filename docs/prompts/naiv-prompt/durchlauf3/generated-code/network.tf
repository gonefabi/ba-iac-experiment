# ==============================================================================
# Virtuelles Netzwerk & Subnetze
# ==============================================================================

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet_address_space]

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_subnet" "user" {
  name                 = "snet-benutzer"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_user_prefix]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-anwendung"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_app_prefix]
}

# ==============================================================================
# Network Security Group – Benutzer-Subnetz
# ==============================================================================
#
# Erlaubt:  RDP (3389) von einer bestimmten Quell-IP
# Blockiert: Alles andere von außen
#
# Ausgehend: Standard-Azure-Regeln (Internet erlaubt)

resource "azurerm_network_security_group" "user" {
  name                = "nsg-benutzer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # --- Eingehend ---------------------------------------------------------------

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
    description                = "RDP-Zugriff nur von der Firmen-IP"
  }

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
    description                = "Alle sonstigen eingehenden Verbindungen blockieren"
  }

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_subnet_network_security_group_association" "user" {
  subnet_id                 = azurerm_subnet.user.id
  network_security_group_id = azurerm_network_security_group.user.id
}

# ==============================================================================
# Network Security Group – Anwendungs-Subnetz
# ==============================================================================
#
# Erlaubt:  SSH (22) nur aus dem Benutzer-Subnetz (internes Management)
# Blockiert: Jeglicher Zugriff von außen
# Ausgehend: Internet explizit blockiert – nur VNet-intern erlaubt

resource "azurerm_network_security_group" "app" {
  name                = "nsg-anwendung"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # --- Eingehend ---------------------------------------------------------------

  security_rule {
    name                       = "Allow-SSH-From-UserSubnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.subnet_user_prefix
    destination_address_prefix = "*"
    description                = "SSH nur aus dem Benutzer-Subnetz"
  }

  security_rule {
    name                       = "Allow-VNet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    description                = "VNet-internen Verkehr erlauben"
  }

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
    description                = "Alle sonstigen eingehenden Verbindungen blockieren"
  }

  # --- Ausgehend ---------------------------------------------------------------

  security_rule {
    name                       = "Allow-VNet-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    description                = "Ausgehend nur innerhalb des VNets"
  }

  security_rule {
    name                       = "Deny-Internet-Outbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
    description                = "Internetzugriff blockieren"
  }

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}
