# ============================================================================
# outputs.tf – Ausgabewerte nach terraform apply
# ============================================================================

output "jumpbox_public_ip" {
  description = "Öffentliche IP-Adresse der Windows Jumpbox (RDP-Zugang)"
  value       = azurerm_public_ip.jumpbox.ip_address
}

output "jumpbox_private_ip" {
  description = "Private IP-Adresse der Windows Jumpbox im snet-user"
  value       = azurerm_network_interface.jumpbox.private_ip_address
}

output "app_private_ip" {
  description = "Private IP-Adresse der Linux App VM im snet-app"
  value       = azurerm_network_interface.app.private_ip_address
}
