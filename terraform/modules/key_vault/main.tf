data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.params.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
}

resource "azurerm_key_vault_access_policy" "function_app_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.function_app_system_principal_id

  # key_permissions = [
  #  "Get", "List"
  # ]

  secret_permissions = [
    "Get", "List"
  ]

  depends_on = [ azurerm_key_vault.key_vault ]
}

resource "azurerm_key_vault_access_policy" "terraform_app_registration_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  # key_permissions = [
  #  "Get", "List"
  # ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

  depends_on = [ azurerm_key_vault.key_vault ]
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.key_vault.id
  depends_on = [ azurerm_key_vault_access_policy.terraform_app_registration_access_policy ]
}