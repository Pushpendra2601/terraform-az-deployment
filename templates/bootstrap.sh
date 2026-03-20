#!/bin/bash
# bootstrap.sh
# Run ONCE before `terraform init` — creates the remote state backend.
# This script is idempotent: safe to run multiple times.

set -e

RESOURCE_GROUP="tfstate-rg"
LOCATION="eastus2"
CONTAINER="tfstate"

# Unique storage account name (lowercase, max 24 chars)
STORAGE_ACCOUNT="tfstatestore$(echo $RANDOM | cut -c1-5)"

echo "==> Creating resource group: $RESOURCE_GROUP"
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION \
  --output none

echo "==> Creating storage account: $STORAGE_ACCOUNT"
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --min-tls-version TLS1_2 \
  --output none

echo "==> Creating tfstate container"
az storage container create \
  --name $CONTAINER \
  --account-name $STORAGE_ACCOUNT \
  --output none

echo ""
echo "   Backend ready. Update provider.tf backend block with:"
echo "   resource_group_name  = \"$RESOURCE_GROUP\""
echo "   storage_account_name = \"$STORAGE_ACCOUNT\""
echo "   container_name       = \"$CONTAINER\""
echo ""
echo "Then run: terraform init"
