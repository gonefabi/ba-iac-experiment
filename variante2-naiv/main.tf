##############################################################################
# main.tf – Provider-Konfiguration und Ressourcengruppe
##############################################################################

terraform {
  required_version = ">= 1.5.0"

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

# ---------------------------------------------------------------------------
# Ressourcengruppe
# ---------------------------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Umgebung = "Produktion"
    Verwalter = "IT-Administration"
  }
}
