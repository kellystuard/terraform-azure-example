###
# Creates Terraform Cloud workspace and associated variables for each application.
# Defined in main.tf/local.applications.
###

data "tfe_oauth_client" "kellystuard" {
  oauth_client_id = "oc-CwWbvaJqJkFY1LoC"
}

resource "tfe_workspace" "applications" {
  for_each = local.application_environments

  name              = "terraform-azure-example-${each.key}"
  description       = each.value.name
  organization      = "kellystuard"
  auto_apply        = false
  execution_mode    = "remote"
  queue_all_runs    = true
  terraform_version = each.value.terraform_version
  
  # for this example, each application is a directory, instead of a separate source control repository
  # for a full implementation, set the source control endpoint and use `vcs_repo.identifier`
  working_directory = each.value.app
  vcs_repo {
    identifier     = "kellystuard/terraform-azure-example"
    branch         = each.value.branch
    oauth_token_id = sensitive(data.tfe_oauth_client.kellystuard.oauth_token_id)
  }
}

resource "tfe_variable" "environment" {
  for_each = local.application_environments

  key          = "environment"
  value        = each.value.env
  category     = "terraform"
  description  = "Environment Short Name"
  workspace_id = tfe_workspace.applications[each.key].id
}

resource "tfe_variable" "azure_resource_group" {
  for_each = local.application_environments

  key          = "azure_resource_group"
  #todo: set from azure resource, to establish dependency
  value        = azurerm_resource_group.applications[each.key].name
  category     = "terraform"
  description  = "Azure Resource Group"
  workspace_id = tfe_workspace.applications[each.key].id
}

resource "tfe_variable" "ARM_SUBSCRIPTION_ID" {
  for_each = local.application_environments

  key          = "ARM_SUBSCRIPTION_ID"
  value        = var.arm_subscription_id
  category     = "env"
  workspace_id = tfe_workspace.applications[each.key].id
}

resource "tfe_variable" "ARM_TENANT_ID" {
  for_each = local.application_environments

  key          = "ARM_TENANT_ID"
  value        = var.arm_tenant_id
  category     = "env"
  workspace_id = tfe_workspace.applications[each.key].id
}

resource "tfe_variable" "ARM_CLIENT_ID" {
  for_each = local.application_environments

  key          = "ARM_CLIENT_ID"
  value        = var.arm_client_id
  category     = "env"
  workspace_id = tfe_workspace.applications[each.key].id
}

resource "tfe_variable" "ARM_CLIENT_SECRET" {
  for_each = local.application_environments

  key          = "ARM_CLIENT_SECRET"
  value        = var.arm_client_secret
  category     = "env"
  workspace_id = tfe_workspace.applications[each.key].id
  sensitive    = true
}
