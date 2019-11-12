resource "azurerm_resource_group" "main" {
  name     = "terraform-azure-example"
  location = var.location
}
resource "azurerm_virtual_network" "main" {
  name                = "main-network"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_lb" "test" {
  name                = "TestLoadBalancer"
  location            = "West US"
  resource_group_name = "${azurerm_resource_group.main.name}"
}
resource "azurerm_lb" "test2" {
  name                = "AnotherLoadBalancer"
  location            = "West US"
  resource_group_name = "${azurerm_resource_group.main.name}"
}