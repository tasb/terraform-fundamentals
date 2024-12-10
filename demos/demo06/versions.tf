terraform {
  backend "local" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"

    }
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = "49175c01-02a7-44bb-b379-2c06f4aae5b4"
}