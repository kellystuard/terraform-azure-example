resource "azurerm_resource_group" "main" {
  name     = "terraform-azure-example-${var.environment}"
  location = var.location
}

# # Uncomment these to show spinning up two module instances
# #module "app1" {
# # source              = "./standard_vm"
# #  name                = "moduleapp1"
# #  resource_group_name = azurerm_resource_group.main.name
# #  location            = azurerm_resource_group.main.location
# #  subnet_id           = azurerm_subnet.internal.id
# #}
# #module "app2" {
# #  source              = "./standard_vm"
# #  name                = "moduleapp2"
# #  resource_group_name = azurerm_resource_group.main.name
# #  location            = azurerm_resource_group.main.location
# # subnet_id           = azurerm_subnet.internal.id
# #}

# # This resource should fail, due to policy
# #resource "azurerm_public_ip" "denied" {
# #  name                = "DeniedPublicIp"
# #  location            = azurerm_resource_group.main.location
# #  resource_group_name = azurerm_resource_group.main.name
# #  allocation_method   = "Static"
# #}
