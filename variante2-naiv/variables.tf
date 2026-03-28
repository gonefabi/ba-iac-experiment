# ==============================================================================
# Variables
# ==============================================================================

variable "project_prefix" {
  description = "Präfix für alle Ressourcennamen"
  type        = string
  default     = "firma"
}

variable "location" {
  description = "Azure-Region"
  type        = string
  default     = "germanywestcentral"
}

variable "vnet_address_space" {
  description = "Adressraum des virtuellen Netzwerks"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_user_prefix" {
  description = "Adressbereich Benutzer-Subnetz"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_app_prefix" {
  description = "Adressbereich Anwendungs-Subnetz"
  type        = string
  default     = "10.0.2.0/24"
}

# --- Windows-VM ---------------------------------------------------------------

variable "win_vm_size" {
  description = "Größe der Windows-VM"
  type        = string
  default     = "Standard_B2ms"
}

variable "win_admin_username" {
  description = "Admin-Benutzername der Windows-VM"
  type        = string
  default     = "azureadmin"
}

variable "win_admin_password" {
  description = "Admin-Passwort der Windows-VM (min. 12 Zeichen, Groß-/Kleinbuchstaben, Zahl, Sonderzeichen)"
  type        = string
  sensitive   = true
}

# --- Linux-VM -----------------------------------------------------------------

variable "linux_vm_size" {
  description = "Größe der Linux-VM"
  type        = string
  default     = "Standard_B2ms"
}

variable "linux_admin_username" {
  description = "Admin-Benutzername der Linux-VM"
  type        = string
  default     = "azureadmin"
}

variable "linux_admin_password" {
  description = "Admin-Passwort der Linux-VM (min. 12 Zeichen)"
  type        = string
  sensitive   = true
}

# --- Zugriffsbeschränkung -----------------------------------------------------

variable "allowed_rdp_source_ip" {
  description = "Öffentliche IP-Adresse (oder CIDR), von der RDP erlaubt ist. '*' = überall (nicht empfohlen)"
  type        = string
}
