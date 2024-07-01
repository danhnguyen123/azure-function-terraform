resource "azurerm_resource_group" "resource_group" {
  name     = "${local.vars.project}-rg"
  location = var.location
}

############# Function ################
module "exchange-rate-crawler" {
  source  = "./modules/function_app"
  resource_group_name = azurerm_resource_group.resource_group.name
  resource_group_id = azurerm_resource_group.resource_group.id
  params = local.vars
  function_app_name  = var.function.function_app_name
  storage_account_name = var.function.storage_account_name
  env = {
    ENVIRONMENT = "${var.function.env_vars.environment}"
    LOG_LEVEL = "${var.function.env_vars.log_level}"
    PRODUCT_NAME = "@Microsoft.KeyVault(VaultName=${var.key_vault.name};SecretName=${var.function.kv_secrets.product_name})"
    STORAGE_DATALAKE = var.storage_account.datalake.name
    DATALAKE_CONTAINER_NAME = "datalake"
    DATALAKE_DIRECTORY_NAME = "datalake_files"

    STORAGE_BLOB = var.storage_account.blob.name
    BLOB_CONTAINER_NAME = "blob"
  }

}

############# Key Vault ################
module "key-vault" {
  source  = "./modules/key_vault"
  key_vault_name = var.key_vault.name
  resource_group_name = azurerm_resource_group.resource_group.name
  params = local.vars
  function_app_system_principal_id = module.exchange-rate-crawler.function_app_system_principal_id

  depends_on = [ module.exchange-rate-crawler ]
}

############# Storage Datalake Gen2 ################
module "storage-account" {
  source  = "./modules/storage_account"
  resource_group_name = azurerm_resource_group.resource_group.name
  storage_account = var.storage_account
  params = local.vars
  depends_on = [ module.exchange-rate-crawler ]
}

############# Event Grid Trigger Function App ################
module "event-grid-pubsub-funcapp" {
  source  = "./modules/event_grid"
  resource_group_name = azurerm_resource_group.resource_group.name
  params = local.vars
  topic_name = var.event_grid.topic_name
  subscription_name = var.event_grid.subscription_name
  function_app_id = module.exchange-rate-crawler.function_app_id
  function_name = var.event_grid.function_name
  depends_on = [ module.exchange-rate-crawler ]
}
