terraform {
  backend "azurerm" {      
    key = "terraform/exchange-rate-analytics/default.tfstate"        
  }
}