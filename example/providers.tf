terraform {
  required_version = "~>1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.66"
    }
  }
}

provider "azurerm" {
  subscription_id = var.arm_subscription_id
  tenant_id       = var.arm_tenant_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
}