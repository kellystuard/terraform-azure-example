terraform {
  required_version = "~>1.0.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.25"
    }
  }
}

provider "tfe" {
  token = var.tfe_token
}