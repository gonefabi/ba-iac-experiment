##############################################################################
# variables.tf – Zentrale Variablen für die Azure-Infrastruktur
##############################################################################

variable "location" {
  description = "Azure-Region für alle Ressourcen"
  type        = string
  default     = "germanywestcentral"
}

variable "resource_group_name" {
  description = "Name der Ressourcengruppe"
  type        = string
  default     = "rg-infrastruktur-prod"
}

variable "vnet_address_space" {
  description = "Adressbereich des virtuellen Netzwerks"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_users_prefix" {
  description = "Adressbereich des Benutzer-Subnetzes"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "subnet_app_prefix" {
  description = "Adressbereich des Anwendungs-Subnetzes"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# --- Windows-VM -----------------------------------------------------------

variable "windows_vm_size" {
  description = "VM-Größe für die Windows-Maschine"
  type        = string
  default     = "Standard_B2s_v2"
}

variable "windows_admin_username" {
  description = "Administrator-Benutzername der Windows-VM"
  type        = string
  default     = "azureadmin"
}

variable "windows_admin_password" {
  description = "Administrator-Passwort der Windows-VM"
  type        = string
  sensitive   = true
}

# --- Linux-VM -------------------------------------------------------------

variable "linux_vm_size" {
  description = "VM-Größe für die Linux-Maschine"
  type        = string
  default     = "Standard_B2s_v2"
}

variable "linux_admin_username" {
  description = "Administrator-Benutzername der Linux-VM"
  type        = string
  default     = "azureadmin"
}

variable "linux_admin_password" {
  description = "Administrator-Passwort der Linux-VM"
  type        = string
  sensitive   = true
}

# --- Zugriffsbeschränkung -------------------------------------------------

variable "allowed_rdp_source_ip" {
  description = "Öffentliche IP-Adresse (CIDR), von der RDP erlaubt ist, z. B. die Büro-IP"
  type        = string
  default     = "*" # Im Produktivbetrieb unbedingt auf die Büro-IP einschränken!
}
