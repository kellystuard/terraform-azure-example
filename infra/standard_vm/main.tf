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
resource "azurerm_network_interface" "app" {
  name                = "vm-${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "vm-${var.name}-configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "app" {
  name                  = "vm-${var.name}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.app.id]
  vm_size               = "Standard_DS1_v2"

  # delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "vm-${var.name}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.name}"
    admin_username = "azureadmin"
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "example"
    os_type = "linux"
    cost_center = var.cost_center
  }
}
