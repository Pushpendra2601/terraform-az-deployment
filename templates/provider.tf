terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  # Remote state is stored in a SEPARATE storage account
  # pre-created by bootstrap.sh — never managed by Terraform itself
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestore"   # replaced by bootstrap.sh output
    container_name       = "tfstate"
    key                  = "week1.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}
