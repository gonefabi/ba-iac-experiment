##############################################################################
# outputs.tf – Ausgaben für BA-IaC-Experiment
##############################################################################

output "windows_vm_public_ip" {
  description = "Öffentliche IP-Adresse der Windows-Jumpbox (vm-kmu-jumpbox)"
  value       = azurerm_public_ip.jumpbox.ip_address
}

output "windows_vm_private_ip" {
  description = "Private IP-Adresse der Windows-Jumpbox (vm-kmu-jumpbox)"
  value       = azurerm_network_interface.jumpbox.private_ip_address
}

output "linux_vm_private_ip" {
  description = "Private IP-Adresse der Linux-App-VM (vm-kmu-app)"
  value       = azurerm_network_interface.app.private_ip_address
}
