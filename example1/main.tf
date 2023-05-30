data "azurerm_resource_group" "main" {
  name     = var.azure_resource_group
}

locals {
  tags = data.azurerm_resource_group.main.tags
}