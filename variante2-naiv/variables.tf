###############################################################################
# Variablen – Passe diese Werte in terraform.tfvars an deine Umgebung an
###############################################################################

# --- Allgemein ---------------------------------------------------------------

variable "prefix" {
  description = "Präfix für alle Ressourcennamen (z. B. Firmenname)"
  type        = string
  default     = "firma"
}

variable "location" {
  description = "Azure-Region"
  type        = string
  default     = "germanywestcentral"
}

variable "common_tags" {
  description = "Tags, die auf alle Ressourcen angewendet werden"
  type        = map(string)
  default = {
    Umgebung  = "Produktion"
    Verwaltet = "Terraform"
  }
}

# --- Netzwerk ----------------------------------------------------------------

variable "vnet_address_space" {
  description = "Adressbereich des virtuellen Netzwerks"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_users_prefix" {
  description = "Adressbereich des Benutzer-Subnetzes"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_app_prefix" {
  description = "Adressbereich des Anwendungs-Subnetzes"
  type        = string
  default     = "10.0.2.0/24"
}

variable "allowed_rdp_source_ip" {
  description = "IP-Adresse oder CIDR, von der RDP erlaubt ist (z. B. Büro-IP)"
  type        = string
  default     = "*" # ACHTUNG: Im Produktivbetrieb auf deine Büro-IP einschränken!
}

# --- Windows-VM --------------------------------------------------------------

variable "windows_vm_size" {
  description = "VM-Größe für die Windows-Maschine"
  type        = string
  default     = "Standard_B2as_v2"  # B2s oft nicht verfügbar in Germany West Central
}

variable "windows_admin_username" {
  description = "Administrator-Benutzername für die Windows-VM"
  type        = string
  default     = "winadmin"
}

variable "windows_admin_password" {
  description = "Administrator-Passwort für die Windows-VM"
  type        = string
  sensitive   = true
}

# --- Linux-VM ----------------------------------------------------------------

variable "linux_vm_size" {
  description = "VM-Größe für die Linux-Maschine"
  type        = string
  default     = "Standard_B2as_v2"  # B2s oft nicht verfügbar in Germany West Central
}

variable "linux_admin_username" {
  description = "Administrator-Benutzername für die Linux-VM"
  type        = string
  default     = "linuxadmin"
}

variable "linux_admin_password" {
  description = "Administrator-Passwort für die Linux-VM"
  type        = string
  sensitive   = true
}
