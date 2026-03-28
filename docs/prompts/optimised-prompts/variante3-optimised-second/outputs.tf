###############################################################################
# outputs.tf – Ausgabewerte für das KMU-Experiment
###############################################################################

output "jumpbox_public_ip" {
  description = "Öffentliche IP-Adresse der Windows-VM (vm-kmu-jumpbox)"
  value       = azurerm_public_ip.jumpbox.ip_address
}

output "jumpbox_private_ip" {
  description = "Private IP-Adresse der Windows-VM (vm-kmu-jumpbox)"
  value       = azurerm_network_interface.jumpbox.private_ip_address
}

output "app_private_ip" {
  description = "Private IP-Adresse der Linux-VM (vm-kmu-app)"
  value       = azurerm_network_interface.app.private_ip_address
}
