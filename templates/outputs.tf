output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "web_app_url" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "application_insights_name" {
  value = azurerm_application_insights.insights.name
}