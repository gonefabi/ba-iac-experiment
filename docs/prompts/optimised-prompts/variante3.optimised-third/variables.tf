##############################################################################
# variables.tf – Variablen für BA-IaC-Experiment
##############################################################################

variable "windows_admin_password" {
  description = "Administrator-Passwort für die Windows-VM (vm-kmu-jumpbox)"
  type        = string
  sensitive   = true
}

variable "linux_admin_password" {
  description = "Administrator-Passwort für die Linux-VM (vm-kmu-app)"
  type        = string
  sensitive   = true
}

variable "admin_source_ip" {
  description = "Quell-IP-Adresse für den RDP-Zugriff auf die Windows-VM (CIDR /32 wird automatisch angehängt)"
  type        = string
  default     = "*"
}
