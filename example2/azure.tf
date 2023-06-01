resource "azurerm_log_analytics_workspace" "example" {
  name                = "logs-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}

resource "azurerm_container_group" "example" {
  name                        = "container-${var.environment}"
  location                    = data.azurerm_resource_group.main.location
  resource_group_name         = data.azurerm_resource_group.main.name
  ip_address_type             = "Public"
  dns_name_label              = "example-${var.environment}"
  os_type                     = "Linux"
  dns_name_label_reuse_policy = "ResourceGroupReuse"
  restart_policy              = "OnFailure"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  diagnostics {
    log_analytics {
      workspace_id  = azurerm_log_analytics_workspace.example.workspace_id
      workspace_key = azurerm_log_analytics_workspace.example.primary_shared_key
    }
  }

  tags = local.tags
}