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

resource "tfe_variable" "cost_center" {
  for_each = local.application_environments

  key          = "cost_center"
  value        = try(each.value.cost_center, each.value.application.cost_center)
  category     = "terraform"
  description  = "Cost Center for Billing"
  workspace_id = tfe_workspace.applications[each.key].id
  # application's cost center > environment's cost center
}
