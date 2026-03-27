###############################################################################
# Variablen – Passe diese Werte in terraform.tfvars an
###############################################################################

# --- Allgemein ---------------------------------------------------------------

variable "prefix" {
  description = "Präfix für alle Ressourcennamen (z.B. Firmenname)"
  type        = string
  default     = "firma"
}

variable "location" {
  description = "Azure-Region"
  type        = string
  default     = "germanywestcentral"
}

variable "common_tags" {
  description = "Tags für alle Ressourcen"
  type        = map(string)
  default = {
    Umgebung = "Produktion"
    Verwalter = "IT-Admin"
  }
}

# --- Netzwerk ----------------------------------------------------------------

variable "vnet_address_space" {
  description = "Adressraum des VNets"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_benutzer_prefix" {
  description = "CIDR des Benutzer-Subnetzes"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_anwendung_prefix" {
  description = "CIDR des Anwendungs-Subnetzes"
  type        = string
  default     = "10.0.2.0/24"
}

variable "admin_source_ip" {
  description = "Deine öffentliche IP-Adresse für RDP-Zugriff (z.B. 203.0.113.10/32)"
  type        = string
  default     = "*"
}

# --- Windows-VM --------------------------------------------------------------

variable "windows_vm_size" {
  description = "VM-Größe für die Windows-VM"
  type        = string
  default     = "Standard_B2s_v2"
}

variable "windows_admin_user" {
  description = "Admin-Benutzername der Windows-VM"
  type        = string
  default     = "adminuser"
}

variable "windows_admin_password" {
  description = "Admin-Passwort der Windows-VM (min. 12 Zeichen, Groß-/Kleinbuchstaben, Zahl, Sonderzeichen)"
  type        = string
  sensitive   = true
}

# --- Linux-VM ----------------------------------------------------------------

variable "linux_vm_size" {
  description = "VM-Größe für die Linux-VM"
  type        = string
  default     = "Standard_B2s_v2"
}

variable "linux_admin_user" {
  description = "Admin-Benutzername der Linux-VM"
  type        = string
  default     = "adminuser"
}

variable "linux_admin_password" {
  description = "Admin-Passwort der Linux-VM"
  type        = string
  sensitive   = true
}
