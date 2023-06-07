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

resource "azurerm_network_interface" "db" {
  name                = "db-nic"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "web-configuration"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "db" {
  name                  = "db-vm"
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = data.azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.db.id]
  size                  = "Standard_B1ls"

  admin_username                  = "example"
  admin_password                  = random_password.password.result
  disable_password_authentication = false

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

  tags = local.tags
}

resource "azurerm_network_interface" "utility" {
  name                = "utility-nic"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "utility-configuration"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "utility" {
  name                  = "utility-vm"
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = data.azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.utility.id]
  size                  = "Standard_B1ls"

  admin_username                  = "example"
  admin_password                  = random_password.password.result
  disable_password_authentication = false

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

  tags = local.tags
}

resource "azurerm_linux_virtual_machine_scale_set" "web" {
  name                = "web-vm"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "Standard_B1ls"
  instances           = 6

  admin_username                  = "example"
  admin_password                  = random_password.password.result
  disable_password_authentication = false

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

  network_interface {
    name    = "web-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.web.id
    }
  }

  tags = local.tags
}
