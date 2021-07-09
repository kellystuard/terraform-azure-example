resource "azurerm_resource_group" "main" {
  name     = "terraform-azure-example-${var.environment}"
  location = var.location
}
