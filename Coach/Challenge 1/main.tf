terraform {
  backend "azurerm" {
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.12.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

provider "azurerm" {
  subscription_id = var.subscription_id_demo
  alias           = "demo"
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {
    # resource_group {
    #   prevent_deletion_if_contains_resources = true
    # }
  }
}


resource "random_string" "random" {
  length  = 2
  numeric = true
  special = false
  upper   = false
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

data "azurerm_client_config" "current" {}
