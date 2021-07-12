resource "azurerm_resource_group" "main" {
  name     = "terraform-azure-example-${var.environment}"
  location = var.location

  tags = {
    application = "example"
    cost_center = var.cost_center
    environment = var.environment
  }
}
