resource "azurerm_resource_group" "main" {
  name     = "terraform-azure-example"
  location = "North Central US"
}
resource "azurerm_virtual_network" "main" {
  name                = "main-network"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
}
