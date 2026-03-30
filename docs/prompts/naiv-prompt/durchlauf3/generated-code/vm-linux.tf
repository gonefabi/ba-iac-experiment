# ==============================================================================
# Linux-VM (Anwendungs-Subnetz) – nur intern erreichbar, kein Internet
# ==============================================================================

resource "azurerm_network_interface" "linux" {
  name                = "nic-linux-anwendung"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
    # Keine public_ip_address_id → kein direkter Internetzugang
  }

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_linux_virtual_machine" "linux" {
  name                            = "vm-linux-app"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = var.linux_vm_size
  zone                            = "1"
  admin_username                  = var.linux_admin_username
  admin_password                  = var.linux_admin_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.linux.id]

  os_disk {
    name                 = "osdisk-linux-app"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = azurerm_resource_group.main.tags
}
