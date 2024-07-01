resource "azurerm_storage_account" "storage-datalake" {
  name                     = var.storage_account.datalake.name
  resource_group_name      = var.resource_group_name
  location                 = var.params.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_account" "storage-blob" {
  name                     = var.storage_account.blob.name
  resource_group_name      = var.resource_group_name
  location                 = var.params.location
  account_kind             = "Storage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

