##############################################################################
# vm-windows.tf – Windows-VM im Benutzer-Subnetz (RDP-Zugang)
##############################################################################

# ---------------------------------------------------------------------------
# Öffentliche IP-Adresse für RDP-Zugriff
# ---------------------------------------------------------------------------
resource "azurerm_public_ip" "windows" {
  name                = "pip-vm-windows"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = azurerm_resource_group.main.tags
}

# ---------------------------------------------------------------------------
# Netzwerkschnittstelle
# ---------------------------------------------------------------------------
resource "azurerm_network_interface" "windows" {
  name                = "nic-vm-windows"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.users.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows.id
  }

  tags = azurerm_resource_group.main.tags
}

# ---------------------------------------------------------------------------
# Windows Server 2022 VM
# ---------------------------------------------------------------------------
resource "azurerm_windows_virtual_machine" "main" {
  name                = "vm-windows-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.windows_vm_size
  admin_username      = var.windows_admin_username
  admin_password      = var.windows_admin_password
  zone                = "1"

  network_interface_ids = [
    azurerm_network_interface.windows.id
  ]

  os_disk {
    name                 = "osdisk-vm-windows-01"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = azurerm_resource_group.main.tags
}
