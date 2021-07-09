resource "azurerm_resource_group" "main" {
  name     = "terraform-azure-example-${var.environment}"
  location = var.location
}

# resource "azurerm_virtual_network" "main" {
#   name                = "main-network"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   address_space       = ["10.0.0.0/16"]
# }
# resource "azurerm_lb" "test" {
#   name                = "TestLoadBalancer"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
# }
# resource "azurerm_subnet" "internal" {
#   name                      = "internal-subnet"
#   resource_group_name       = azurerm_resource_group.main.name
#   virtual_network_name      = azurerm_virtual_network.main.name
#   address_prefix            = "10.0.2.0/24"
#   network_security_group_id = azurerm_network_security_group.internal.id
# }
# resource "azurerm_network_security_group" "internal" {
#   name                = "InternalSecurityGroup"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   security_rule {
#     name                       = "testRDP"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Deny"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
# resource "azurerm_subnet_network_security_group_association" "internal" {
#   subnet_id                 = azurerm_subnet.internal.id
#   network_security_group_id = azurerm_network_security_group.internal.id
# }

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
