# ============================================================================
# variables.tf – Eingabevariablen für das KMU-IaC-Experiment
# ============================================================================

variable "windows_admin_password" {
  description = "Administrator-Passwort für die Windows Jumpbox VM"
  type        = string
  sensitive   = true
}

variable "linux_admin_password" {
  description = "Administrator-Passwort für die Linux App VM"
  type        = string
  sensitive   = true
}

variable "admin_source_ip" {
  description = "Quell-IP-Adresse für den RDP-Zugriff auf die Jumpbox (CIDR /32 wird automatisch angehängt)"
  type        = string
  default     = "*"
}
