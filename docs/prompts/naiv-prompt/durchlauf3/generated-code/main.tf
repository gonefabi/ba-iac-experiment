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
