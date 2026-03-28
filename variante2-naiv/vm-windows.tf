# ==============================================================================
# Windows-VM (Benutzer-Subnetz) – RDP-Zugriff über öffentliche IP
# ==============================================================================

resource "azurerm_public_ip" "win" {
  name                = "pip-win-benutzer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_network_interface" "win" {
  name                = "nic-win-benutzer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.user.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.win.id
  }

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_windows_virtual_machine" "win" {
  name                = "vm-win-benutzer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.win_vm_size
  admin_username      = var.win_admin_username
  admin_password      = var.win_admin_password

  network_interface_ids = [azurerm_network_interface.win.id]

  os_disk {
    name                 = "osdisk-win-benutzer"
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
