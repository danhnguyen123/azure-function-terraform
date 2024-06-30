locals {
    timestamp = formatdate("YYMMDDhhmmss", timestamp())  # this is kind of annoying but makes function deploy every time
}

data "archive_file" "source" {
    type = "zip"
    excludes    = split("\n", file("${path.root}/../src/${var.function_app_name}/.funcignore"))
    source_dir = "${path.root}/../src/${var.function_app_name}" # Directory where your Python source code is
    output_path = "${path.root}/src-${var.function_app_name}-${local.timestamp}.zip"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = var.resource_group_name
  location                 = var.params.location
  account_kind             = "Storage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_insights" "application_insight" {
  name                = "${var.function_app_name}-appinsight"
  resource_group_name = var.resource_group_name
  location            = var.params.location
  application_type    = "other"
}

resource "azurerm_application_insights_smart_detection_rule" "memory_leak" {
  name                    = "Potential memory leak detected"
  application_insights_id = azurerm_application_insights.application_insight.id
  enabled                 = false
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "${var.function_app_name}-asp"
  resource_group_name = var.resource_group_name
  location            = var.params.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "function_app" {
  name                        = "${var.function_app_name}-funcapp"
  resource_group_name         = var.resource_group_name
  location                    = var.params.location
  service_plan_id             = azurerm_service_plan.app_service_plan.id
  storage_account_name        = azurerm_storage_account.storage_account.name
  storage_account_access_key  = azurerm_storage_account.storage_account.primary_access_key
  functions_extension_version = "~4"
  app_settings = merge({
    ENABLE_ORYX_BUILD              = "true"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    FUNCTIONS_WORKER_RUNTIME       = "python"
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.application_insight.instrumentation_key}"
    },
    var.env
  )

  site_config {
    application_stack {
      python_version = "3.10"
    }
    cors {
      allowed_origins = ["*"]
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["SCM_DO_BUILD_DURING_DEPLOYMENT"]
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  zip_deploy_file = data.archive_file.source.output_path

  depends_on = [data.archive_file.source, 
                azurerm_storage_account.storage_account, 
                azurerm_application_insights.application_insight,
                azurerm_service_plan.app_service_plan
                ]
}

# and the role assignment to this identity
resource "azurerm_role_assignment" "funcapp-storage-contributor" {
  scope              = var.resource_group_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id       = azurerm_linux_function_app.function_app.identity[0].principal_id
}