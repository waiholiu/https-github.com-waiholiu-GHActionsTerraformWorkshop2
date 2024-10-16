terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.4.0"
    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = "<insert>"
    use_cli = true
    resource_provider_registrations = "none"
 }