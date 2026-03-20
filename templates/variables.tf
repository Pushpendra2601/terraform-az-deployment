variable "resource_group_name" {
  type        = string
  default     = "terraform-devops-rg"
  description = "Name of the Azure Resource Group"
}

variable "location" {
  type        = string
  default     = "eastus2"
  description = "Azure region for all resources"
}

variable "app_service_plan_name" {
  type        = string
  default     = "terraform-devops-plan"
  description = "Name of the App Service Plan (F1 = free tier)"
}

variable "web_app_name" {
  type        = string
  default     = "terraform-devops-app-12345"
  description = "Name of the Linux Web App (must be globally unique)"
}

variable "storage_account_name" {
  type        = string
  default     = "terraformdevopsstore123"
  description = "Name of the Storage Account (also used for Terraform remote state)"
}

variable "keyvault_name" {
  type        = string
  default     = "terraformdevopskv123"
  description = "Name of the Key Vault (must be globally unique)"
}

variable "appinsights_name" {
  type        = string
  default     = "terraform-devops-insights"
  description = "Name of the Application Insights resource"
}
