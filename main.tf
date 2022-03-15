terraform {
  required_version = ">= 1.1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.99.0"
    }
  }
}

provider "azurerm" {
  features {}
}
