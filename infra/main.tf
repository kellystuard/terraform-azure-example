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
  resource_group_name = azurerm_resource_group.main.name
}
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}
module "standard_vm" {
  source              = "./modules/standard_vm"
  name                = "app1"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.internal.id
}
