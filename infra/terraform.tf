###
# Creates Terraform Cloud workspace and associated variables for each application.
# Defined in main.tf/local.applications.
###

data "tfe_oauth_client" "kellystuard" {
  oauth_client_id = "oc-CwWbvaJqJkFY1LoC"
}

resource "tfe_workspace" "applications" {
  for_each = local.application_environments

  name              = "terraform-azure-${each.key}"
  description       = each.value.name
  organization      = "kellystuard"
  auto_apply        = true
  execution_mode    = "remote"
  queue_all_runs    = true
  terraform_version = try(each.value.application.terraform_version, local.application_defaults.terraform_version)
  # application's version > default version

  # for this example, each application is a directory, instead of a separate source control repository
  working_directory = each.value.application.id
  vcs_repo {
    identifier     = "kellystuard/terraform-azure-example"
    branch         = try(each.value.branch, local.application_defaults.environments[each.value.id], null)
    oauth_token_id = sensitive(data.tfe_oauth_client.kellystuard.oauth_token_id)
    # environment's branch > default branch by known name > source control's configured default branch (typically `main`)
  }
}

resource "tfe_variable" "environment" {
  for_each = local.application_environments

  key          = "environment"
  value        = each.value.id
  category     = "terraform"
  description  = "Environment Name"
  workspace_id = tfe_workspace.applications[each.key].id
}

resource "tfe_variable" "cost_center" {
  for_each = local.application_environments

  key          = "cost_center"
  value        = try(each.value.cost_center, each.value.application.cost_center)
  category     = "terraform"
  description  = "Cost Center for Billing"
  workspace_id = tfe_workspace.applications[each.key].id
  # application's cost center > environment's cost center
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
