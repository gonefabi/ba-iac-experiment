# ==============================================================================
# Terraform & Provider
# ==============================================================================

terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  # ---------------------------------------------------------------------------
  # Remote-Backend: Speichert den Terraform-State in Azure Blob Storage,
  # damit er zwischen Pipeline-Läufen erhalten bleibt.
  #
  # VORAUSSETZUNG: bootstrap-backend.sh einmalig ausführen.
  # ---------------------------------------------------------------------------
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstatefirma"
    container_name       = "tfstate"
    key                  = "firma-prod.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# ==============================================================================
# Ressourcengruppe
# ==============================================================================

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_prefix}-prod"
  location = var.location

  tags = {
    Umgebung = "Produktion"
    Projekt  = var.project_prefix
  }
}
