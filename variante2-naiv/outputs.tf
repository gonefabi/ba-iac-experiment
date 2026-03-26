##############################################################################
# outputs.tf – Wichtige Ausgaben nach dem Deployment
##############################################################################

output "resource_group_name" {
  description = "Name der Ressourcengruppe"
  value       = azurerm_resource_group.main.name
}

output "vnet_name" {
  description = "Name des virtuellen Netzwerks"
  value       = azurerm_virtual_network.main.name
}

output "windows_vm_public_ip" {
  description = "Öffentliche IP-Adresse der Windows-VM (für RDP-Verbindung)"
  value       = azurerm_public_ip.windows.ip_address
}

output "windows_vm_private_ip" {
  description = "Private IP-Adresse der Windows-VM"
  value       = azurerm_network_interface.windows.private_ip_address
}

output "linux_vm_private_ip" {
  description = "Private IP-Adresse der Linux-VM (nur intern erreichbar)"
  value       = azurerm_network_interface.linux.private_ip_address
}

output "rdp_connection_command" {
  description = "Befehl zum Verbinden per RDP"
  value       = "mstsc /v:${azurerm_public_ip.windows.ip_address}"
}
