# automatically create the appropriately-named resource group in Azure
resource "azurerm_resource_group" "applications" {
  for_each = local.application_environments

  name     = "terraform-azure-example-${each.key}"
  location = each.value.azure_location

  tags = {
    application = each.value.app
    cost_center = each.value.cost_center
    description = each.value.name
    environment = each.value.env
  }
}
