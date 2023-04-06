terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-uks-backend"
    storage_account_name = "st6zyw77uj"
    container_name       = "tfstate6zyw77uj"
    key                  = "application.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}