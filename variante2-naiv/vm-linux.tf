##############################################################################
# vm-linux.tf – Linux-VM im Anwendungs-Subnetz (nur intern erreichbar)
##############################################################################

# ---------------------------------------------------------------------------
# Netzwerkschnittstelle – KEINE öffentliche IP
# ---------------------------------------------------------------------------
resource "azurerm_network_interface" "linux" {
  name                = "nic-vm-linux"
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

# ---------------------------------------------------------------------------
# Ubuntu 22.04 LTS VM
# ---------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "main" {
  name                            = "vm-linux-01"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = var.linux_vm_size
  admin_username                  = var.linux_admin_username
  admin_password                  = var.linux_admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.linux.id
  ]

  os_disk {
    name                 = "osdisk-vm-linux-01"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = azurerm_resource_group.main.tags
}
