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
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}
