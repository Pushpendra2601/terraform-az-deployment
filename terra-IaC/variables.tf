variable "resource_group_name" {
  default = "terraform-devops-rg"
}

variable "location" {
  default = "eastus2"
}

variable "app_service_plan_name" {
  default = "terraform-devops-plan"
}

variable "web_app_name" {
  default = "terraform-devops-app-12345"
}

variable "storage_account_name" {
  default = "terraformdevopsstore123"
}

variable "keyvault_name" {
  default = "terraformdevopskv123"
}

variable "appinsights_name" {
  default = "terraform-devops-insights"
}