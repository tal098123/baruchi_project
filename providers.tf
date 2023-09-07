terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
   features {}
   subscription_id = "f99fd6bf-e5f7-4050-8a87-7b12f5d4bb9f"
}

