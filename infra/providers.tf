terraform {
  required_version = "~>1.4"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.45"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.58"
    }

  }
}

provider "tfe" {
  token = var.tfe_token
}

provider "azurerm" {
  subscription_id = var.arm_subscription_id
  tenant_id       = var.arm_tenant_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret

  features {}
}
