resource "random_password" "password" {
  # The supplied password must be between 6-72 characters long
  # and must satisfy at least 3 of password complexity requirements from the following:
  # 1) Contains an uppercase character
  # 2) Contains a lowercase character
  # 3) Contains a numeric digit
  # 4) Contains a special character
  # 5) Control characters are not allowed
  length      = 70
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}
resource "azurerm_network_interface" "example" {
  name                = "nic-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "example-configuration-${var.environment}"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "db" {
  name                  = "db-vm-${var.environment}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.example.id]
  size                  = "A1_v2"

  admin_username                  = "example"
  admin_password                  = random_password.password.result
  disable_password_authentication = false

  priority        = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price   = -1

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }
  tags = {
    application = "example"
    environment = var.environment
    os_type     = "linux"
  }
}
