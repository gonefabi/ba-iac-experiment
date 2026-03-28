#!/usr/bin/env bash
# ==============================================================================
# bootstrap-backend.sh
# Erstellt den Azure Storage Account für den Terraform-Remote-State.
# Einmalig ausführen, BEVOR die Pipeline das erste Mal läuft.
# ==============================================================================
set -euo pipefail

RESOURCE_GROUP="rg-terraform-state"
LOCATION="germanywestcentral"
# Storage-Account-Name muss global eindeutig sein (3-24 Zeichen, nur Kleinbuchstaben + Zahlen).
# Passe den Namen bei Bedarf an:
STORAGE_ACCOUNT="stterraformstate$(openssl rand -hex 4)"
CONTAINER_NAME="tfstate"

echo "==> Erstelle Ressourcengruppe: ${RESOURCE_GROUP}"
az group create \
  --name "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --output none

echo "==> Erstelle Storage Account: ${STORAGE_ACCOUNT}"
az storage account create \
  --name "${STORAGE_ACCOUNT}" \
  --resource-group "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --sku "Standard_LRS" \
  --kind "StorageV2" \
  --min-tls-version "TLS1_2" \
  --allow-blob-public-access false \
  --output none

echo "==> Erstelle Blob-Container: ${CONTAINER_NAME}"
az storage container create \
  --name "${CONTAINER_NAME}" \
  --account-name "${STORAGE_ACCOUNT}" \
  --auth-mode login \
  --output none

echo ""
echo "=========================================="
echo " Backend-Storage erfolgreich erstellt!"
echo "=========================================="
echo ""
echo " Trage diese Werte in main.tf ein:"
echo ""
echo "   resource_group_name  = \"${RESOURCE_GROUP}\""
echo "   storage_account_name = \"${STORAGE_ACCOUNT}\""
echo "   container_name       = \"${CONTAINER_NAME}\""
echo "   key                  = \"firma-prod.tfstate\""
echo ""
echo " Danach: terraform init -reconfigure"
echo "=========================================="
