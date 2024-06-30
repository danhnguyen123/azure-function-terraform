resource "azurerm_eventgrid_topic" "topic" {
  name                = var.topic_name
  location            = var.params.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_eventgrid_event_subscription" "subscription" {
  name  = var.subscription_name
  scope = azurerm_eventgrid_topic.topic.id

  azure_function_endpoint {
    function_id = "${var.function_app_id}/functions/${var.function_name}"
  }
}