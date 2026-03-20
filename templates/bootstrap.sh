#!/bin/bash
# bootstrap.sh
# Run ONCE before `terraform init` — creates the remote state backend.
# This script is idempotent: safe to run multiple times.

set -e

RESOURCE_GROUP="tfstate-rg"
LOCATION="eastus2"
CONTAINER="tfstate"

# Use subscription ID suffix to ensure uniqueness across Azure
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
STORAGE_ACCOUNT="tfstate$(echo $SUBSCRIPTION_ID | tr -d '-' | cut -c1-16)"

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

# Automatically update provider.tf with the correct storage account name
sed -i "s/storage_account_name.*=.*/storage_account_name = \"$STORAGE_ACCOUNT\"/" provider.tf

echo ""
echo "✅ Backend ready and provider.tf updated automatically."
echo "   Storage account: $STORAGE_ACCOUNT"