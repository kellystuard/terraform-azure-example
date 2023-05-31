resource "azurerm_log_analytics_workspace" "example" {
  name                = "logs-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}

resource "azurerm_container_app_environment" "example" {
  name                       = "example-environment-${var.environment}"
  location                   = data.azurerm_resource_group.main.location
  resource_group_name        = data.azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  tags = local.tags
}

resource "azurerm_container_app" "example" {
  name                         = "example-app-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.example.id
  resource_group_name          = data.azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "docker.io/chrch/docker-pets:1.0"
      #image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage = 100
    }
  }

  tags = local.tags
}
