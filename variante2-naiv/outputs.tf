# ==============================================================================
# Ausgaben
# ==============================================================================

output "resource_group_name" {
  description = "Name der Ressourcengruppe"
  value       = azurerm_resource_group.main.name
}

output "vnet_name" {
  description = "Name des virtuellen Netzwerks"
  value       = azurerm_virtual_network.main.name
}

output "win_vm_public_ip" {
  description = "Öffentliche IP der Windows-VM (für RDP-Verbindung)"
  value       = azurerm_public_ip.win.ip_address
}

output "win_vm_private_ip" {
  description = "Private IP der Windows-VM"
  value       = azurerm_network_interface.win.private_ip_address
}

output "linux_vm_private_ip" {
  description = "Private IP der Linux-VM (nur intern erreichbar)"
  value       = azurerm_network_interface.linux.private_ip_address
}

output "rdp_connection_string" {
  description = "RDP-Verbindungsbefehl"
  value       = "mstsc /v:${azurerm_public_ip.win.ip_address}"
}

output "ssh_via_jumphost" {
  description = "SSH zur Linux-VM über die Windows-VM als Jump-Host"
  value       = "Von der Windows-VM aus: ssh ${var.linux_admin_username}@${azurerm_network_interface.linux.private_ip_address}"
}
