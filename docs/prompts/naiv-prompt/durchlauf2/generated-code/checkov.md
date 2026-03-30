
       _               _
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V /
  \___|_| |_|\___|\___|_|\_\___/ \_/

By Prisma Cloud | version: 3.2.513 

terraform scan results:

Passed checks: 20, Failed checks: 8, Skipped checks: 0

Check: CKV_AZURE_183: "Ensure that VNET uses local DNS addresses"
	PASSED for resource: azurerm_virtual_network.main
	File: /main.tf:43-50
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/azr-networking-183
Check: CKV_AZURE_182: "Ensure that VNET has at least 2 connected DNS Endpoints"
	PASSED for resource: azurerm_virtual_network.main
	File: /main.tf:43-50
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/azr-networking-182
Check: CKV_AZURE_10: "Ensure that SSH access is restricted from the internet"
	PASSED for resource: azurerm_network_security_group.benutzer
	File: /main.tf:72-117
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/bc-azr-networking-3
Check: CKV_AZURE_77: "Ensure that UDP Services are restricted from the Internet "
	PASSED for resource: azurerm_network_security_group.benutzer
	File: /main.tf:72-117
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-that-udp-services-are-restricted-from-the-internet
Check: CKV_AZURE_160: "Ensure that HTTP (port 80) access is restricted from the internet"
	PASSED for resource: azurerm_network_security_group.benutzer
	File: /main.tf:72-117
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-azure-http-port-80-access-from-the-internet-is-restricted
Check: CKV_AZURE_10: "Ensure that SSH access is restricted from the internet"
	PASSED for resource: azurerm_network_security_group.anwendung
	File: /main.tf:121-179
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/bc-azr-networking-3
Check: CKV_AZURE_77: "Ensure that UDP Services are restricted from the Internet "
	PASSED for resource: azurerm_network_security_group.anwendung
	File: /main.tf:121-179
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-that-udp-services-are-restricted-from-the-internet
Check: CKV_AZURE_9: "Ensure that RDP access is restricted from the internet"
	PASSED for resource: azurerm_network_security_group.anwendung
	File: /main.tf:121-179
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/bc-azr-networking-2
Check: CKV_AZURE_160: "Ensure that HTTP (port 80) access is restricted from the internet"
	PASSED for resource: azurerm_network_security_group.anwendung
	File: /main.tf:121-179
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-azure-http-port-80-access-from-the-internet-is-restricted
Check: CKV_AZURE_118: "Ensure that Network Interfaces disable IP forwarding"
	PASSED for resource: azurerm_network_interface.windows
	File: /main.tf:230-243
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-that-network-interfaces-disable-ip-forwarding
Check: CKV_AZURE_179: "Ensure VM agent is installed"
	PASSED for resource: azurerm_windows_virtual_machine.main
	File: /main.tf:245-269
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/azr-general-179
Check: CKV_AZURE_177: "Ensure Windows VM enables automatic updates"
	PASSED for resource: azurerm_windows_virtual_machine.main
	File: /main.tf:245-269
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/azr-general-177
Check: CKV_AZURE_92: "Ensure that Virtual Machines use managed disks"
	PASSED for resource: azurerm_windows_virtual_machine.main
	File: /main.tf:245-269
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/ensure-that-virtual-machines-use-managed-disks
Check: CKV_AZURE_118: "Ensure that Network Interfaces disable IP forwarding"
	PASSED for resource: azurerm_network_interface.linux
	File: /main.tf:275-288
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-that-network-interfaces-disable-ip-forwarding
Check: CKV_AZURE_179: "Ensure VM agent is installed"
	PASSED for resource: azurerm_linux_virtual_machine.main
	File: /main.tf:290-315
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/azr-general-179
Check: CKV_AZURE_92: "Ensure that Virtual Machines use managed disks"
	PASSED for resource: azurerm_linux_virtual_machine.main
	File: /main.tf:290-315
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/ensure-that-virtual-machines-use-managed-disks
Check: CKV_AZURE_119: "Ensure that Network Interfaces don't use public IPs"
	PASSED for resource: azurerm_network_interface.linux
	File: /main.tf:275-288
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-that-network-interfaces-dont-use-public-ips
Check: CKV2_AZURE_31: "Ensure VNET subnet is configured with a Network Security Group (NSG)"
	PASSED for resource: azurerm_subnet.benutzer
	File: /main.tf:52-57
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/bc-azure-2-31
Check: CKV2_AZURE_31: "Ensure VNET subnet is configured with a Network Security Group (NSG)"
	PASSED for resource: azurerm_subnet.anwendung
	File: /main.tf:59-64
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/bc-azure-2-31
Check: CKV2_AZURE_39: "Ensure Azure VM is not configured with public IP and serial console access"
	PASSED for resource: azurerm_network_interface.linux
	File: /main.tf:275-288
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/bc-azure-2-39
Check: CKV_AZURE_9: "Ensure that RDP access is restricted from the internet"
	FAILED for resource: azurerm_network_security_group.benutzer
	File: /main.tf:72-117
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/bc-azr-networking-2

		72  | resource "azurerm_network_security_group" "benutzer" {
		73  |   name                = "${var.prefix}-nsg-benutzer"
		74  |   location            = azurerm_resource_group.main.location
		75  |   resource_group_name = azurerm_resource_group.main.name
		76  | 
		77  |   # RDP-Zugriff nur von deiner Admin-IP
		78  |   security_rule {
		79  |     name                       = "Allow-RDP-Inbound"
		80  |     priority                   = 100
		81  |     direction                  = "Inbound"
		82  |     access                     = "Allow"
		83  |     protocol                   = "Tcp"
		84  |     source_port_range          = "*"
		85  |     destination_port_range     = "3389"
		86  |     source_address_prefix      = var.admin_source_ip
		87  |     destination_address_prefix = "*"
		88  |   }
		89  | 
		90  |   # Kommunikation aus dem Anwendungs-Subnetz erlauben
		91  |   security_rule {
		92  |     name                       = "Allow-App-Subnet-Inbound"
		93  |     priority                   = 200
		94  |     direction                  = "Inbound"
		95  |     access                     = "Allow"
		96  |     protocol                   = "*"
		97  |     source_port_range          = "*"
		98  |     destination_port_range     = "*"
		99  |     source_address_prefix      = var.subnet_anwendung_prefix
		100 |     destination_address_prefix = "*"
		101 |   }
		102 | 
		103 |   # Alles andere eingehend blockieren
		104 |   security_rule {
		105 |     name                       = "Deny-All-Inbound"
		106 |     priority                   = 4096
		107 |     direction                  = "Inbound"
		108 |     access                     = "Deny"
		109 |     protocol                   = "*"
		110 |     source_port_range          = "*"
		111 |     destination_port_range     = "*"
		112 |     source_address_prefix      = "*"
		113 |     destination_address_prefix = "*"
		114 |   }
		115 | 
		116 |   tags = var.common_tags
		117 | }

Check: CKV_AZURE_50: "Ensure Virtual Machine Extensions are not Installed"
	FAILED for resource: azurerm_windows_virtual_machine.main
	File: /main.tf:245-269
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/bc-azr-general-14

		245 | resource "azurerm_windows_virtual_machine" "main" {
		246 |   name                  = "${var.prefix}-vm-win"
		247 |   location              = azurerm_resource_group.main.location
		248 |   resource_group_name   = azurerm_resource_group.main.name
		249 |   size                  = var.windows_vm_size
		250 |   zone                  = "1"
		251 |   admin_username        = var.windows_admin_user
		252 |   admin_password        = var.windows_admin_password
		253 |   network_interface_ids = [azurerm_network_interface.windows.id]
		254 | 
		255 |   os_disk {
		256 |     caching              = "ReadWrite"
		257 |     storage_account_type = "StandardSSD_LRS"
		258 |     disk_size_gb         = 128
		259 |   }
		260 | 
		261 |   source_image_reference {
		262 |     publisher = "MicrosoftWindowsServer"
		263 |     offer     = "WindowsServer"
		264 |     sku       = "2022-datacenter-azure-edition"
		265 |     version   = "latest"
		266 |   }
		267 | 
		268 |   tags = var.common_tags
		269 | }

Check: CKV_AZURE_151: "Ensure Windows VM enables encryption"
	FAILED for resource: azurerm_windows_virtual_machine.main
	File: /main.tf:245-269
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-iam-policies/ensure-azure-windows-vm-enables-encryption

		245 | resource "azurerm_windows_virtual_machine" "main" {
		246 |   name                  = "${var.prefix}-vm-win"
		247 |   location              = azurerm_resource_group.main.location
		248 |   resource_group_name   = azurerm_resource_group.main.name
		249 |   size                  = var.windows_vm_size
		250 |   zone                  = "1"
		251 |   admin_username        = var.windows_admin_user
		252 |   admin_password        = var.windows_admin_password
		253 |   network_interface_ids = [azurerm_network_interface.windows.id]
		254 | 
		255 |   os_disk {
		256 |     caching              = "ReadWrite"
		257 |     storage_account_type = "StandardSSD_LRS"
		258 |     disk_size_gb         = 128
		259 |   }
		260 | 
		261 |   source_image_reference {
		262 |     publisher = "MicrosoftWindowsServer"
		263 |     offer     = "WindowsServer"
		264 |     sku       = "2022-datacenter-azure-edition"
		265 |     version   = "latest"
		266 |   }
		267 | 
		268 |   tags = var.common_tags
		269 | }

Check: CKV_AZURE_149: "Ensure that Virtual machine does not enable password authentication"
	FAILED for resource: azurerm_linux_virtual_machine.main
	File: /main.tf:290-315
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/ensure-azure-virtual-machine-does-not-enable-password-authentication

		290 | resource "azurerm_linux_virtual_machine" "main" {
		291 |   name                            = "${var.prefix}-vm-linux"
		292 |   location                        = azurerm_resource_group.main.location
		293 |   resource_group_name             = azurerm_resource_group.main.name
		294 |   size                            = var.linux_vm_size
		295 |   zone                            = "1"
		296 |   admin_username                  = var.linux_admin_user
		297 |   disable_password_authentication = false
		298 |   admin_password                  = var.linux_admin_password
		299 |   network_interface_ids           = [azurerm_network_interface.linux.id]
		300 | 
		301 |   os_disk {
		302 |     caching              = "ReadWrite"
		303 |     storage_account_type = "StandardSSD_LRS"
		304 |     disk_size_gb         = 64
		305 |   }
		306 | 
		307 |   source_image_reference {
		308 |     publisher = "Canonical"
		309 |     offer     = "ubuntu-24_04-lts"
		310 |     sku       = "server"
		311 |     version   = "latest"
		312 |   }
		313 | 
		314 |   tags = var.common_tags
		315 | }

Check: CKV_AZURE_1: "Ensure Azure Instance does not use basic authentication(Use SSH Key Instead)"
	FAILED for resource: azurerm_linux_virtual_machine.main
	File: /main.tf:290-315
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/bc-azr-networking-1

		290 | resource "azurerm_linux_virtual_machine" "main" {
		291 |   name                            = "${var.prefix}-vm-linux"
		292 |   location                        = azurerm_resource_group.main.location
		293 |   resource_group_name             = azurerm_resource_group.main.name
		294 |   size                            = var.linux_vm_size
		295 |   zone                            = "1"
		296 |   admin_username                  = var.linux_admin_user
		297 |   disable_password_authentication = false
		298 |   admin_password                  = var.linux_admin_password
		299 |   network_interface_ids           = [azurerm_network_interface.linux.id]
		300 | 
		301 |   os_disk {
		302 |     caching              = "ReadWrite"
		303 |     storage_account_type = "StandardSSD_LRS"
		304 |     disk_size_gb         = 64
		305 |   }
		306 | 
		307 |   source_image_reference {
		308 |     publisher = "Canonical"
		309 |     offer     = "ubuntu-24_04-lts"
		310 |     sku       = "server"
		311 |     version   = "latest"
		312 |   }
		313 | 
		314 |   tags = var.common_tags
		315 | }

Check: CKV_AZURE_50: "Ensure Virtual Machine Extensions are not Installed"
	FAILED for resource: azurerm_linux_virtual_machine.main
	File: /main.tf:290-315
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/bc-azr-general-14

		290 | resource "azurerm_linux_virtual_machine" "main" {
		291 |   name                            = "${var.prefix}-vm-linux"
		292 |   location                        = azurerm_resource_group.main.location
		293 |   resource_group_name             = azurerm_resource_group.main.name
		294 |   size                            = var.linux_vm_size
		295 |   zone                            = "1"
		296 |   admin_username                  = var.linux_admin_user
		297 |   disable_password_authentication = false
		298 |   admin_password                  = var.linux_admin_password
		299 |   network_interface_ids           = [azurerm_network_interface.linux.id]
		300 | 
		301 |   os_disk {
		302 |     caching              = "ReadWrite"
		303 |     storage_account_type = "StandardSSD_LRS"
		304 |     disk_size_gb         = 64
		305 |   }
		306 | 
		307 |   source_image_reference {
		308 |     publisher = "Canonical"
		309 |     offer     = "ubuntu-24_04-lts"
		310 |     sku       = "server"
		311 |     version   = "latest"
		312 |   }
		313 | 
		314 |   tags = var.common_tags
		315 | }

Check: CKV_AZURE_178: "Ensure linux VM enables SSH with keys for secure communication"
	FAILED for resource: azurerm_linux_virtual_machine.main
	File: /main.tf:290-315
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-general-policies/azr-general-178

		290 | resource "azurerm_linux_virtual_machine" "main" {
		291 |   name                            = "${var.prefix}-vm-linux"
		292 |   location                        = azurerm_resource_group.main.location
		293 |   resource_group_name             = azurerm_resource_group.main.name
		294 |   size                            = var.linux_vm_size
		295 |   zone                            = "1"
		296 |   admin_username                  = var.linux_admin_user
		297 |   disable_password_authentication = false
		298 |   admin_password                  = var.linux_admin_password
		299 |   network_interface_ids           = [azurerm_network_interface.linux.id]
		300 | 
		301 |   os_disk {
		302 |     caching              = "ReadWrite"
		303 |     storage_account_type = "StandardSSD_LRS"
		304 |     disk_size_gb         = 64
		305 |   }
		306 | 
		307 |   source_image_reference {
		308 |     publisher = "Canonical"
		309 |     offer     = "ubuntu-24_04-lts"
		310 |     sku       = "server"
		311 |     version   = "latest"
		312 |   }
		313 | 
		314 |   tags = var.common_tags
		315 | }

Check: CKV_AZURE_119: "Ensure that Network Interfaces don't use public IPs"
	FAILED for resource: azurerm_network_interface.windows
	File: /main.tf:230-243
	Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/azure-policies/azure-networking-policies/ensure-that-network-interfaces-dont-use-public-ips

		230 | resource "azurerm_network_interface" "windows" {
		231 |   name                = "${var.prefix}-nic-win"
		232 |   location            = azurerm_resource_group.main.location
		233 |   resource_group_name = azurerm_resource_group.main.name
		234 | 
		235 |   ip_configuration {
		236 |     name                          = "internal"
		237 |     subnet_id                     = azurerm_subnet.benutzer.id
		238 |     private_ip_address_allocation = "Dynamic"
		239 |     public_ip_address_id          = azurerm_public_ip.windows.id
		240 |   }
		241 | 
		242 |   tags = var.common_tags
		243 | }
