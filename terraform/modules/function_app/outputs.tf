output "function_app_name" {
  value = azurerm_linux_function_app.function_app.name
  description = "Deployed function app name"
}

output "function_app_id" {
  value = azurerm_linux_function_app.function_app.id
  description = "Deployed function app ID"
}

output "function_app_default_hostname" {
  value = azurerm_linux_function_app.function_app.default_hostname
  description = "Deployed function app hostname"
}

output "function_app_system_principal_id" {
  value = azurerm_linux_function_app.function_app.identity[0].principal_id
  description = "SystemAssigned Principal ID"
}