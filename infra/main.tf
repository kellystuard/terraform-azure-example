##
# All applications and their environments are defined in `local.applications`.
# They are flattened and denormalized into `local.application_environments`.
# From there, they are used to create all the boilerplate resources that allow
# application self-service.
##

locals {
  ##
  # This area is used to define the applications and environments. It is created 
  # at the request of the application owners and updated as they need additional 
  # environments or metadata about the applicaiton changes.
  ##
  applications = {
    example1 = {
      cost_center = "88149" # default cost center for all environments
      environments = {
        dev = {
          name   = "Example 1 Development"
        }
      }
    }
  }

  ##
  # This area is used to define the defaults for applications and environments. If 
  # not specified at the application or environment level, these become the values 
  # used. Environment > Application > Environment Default > Application Default
  ##
  application_defaults = {
    terraform_version = "1.4.6"
    azure_location = "North Central US"
    environments = {
      dev = {
        branch = null
      }
      tst = {
        branch = "test"
      }
      prd = {
        branch = "prod"
      }
    }
  }

  ##
  # This area is used to merge the applications with defaults and put it in a format 
  # more easily consumable by Terraform resources.
  ##
  application_environments = { for ae in flatten([
    for appk, appv in local.applications : [
      # application-environment > application > application-environment defaults > application defaults
      for envk, envv in appv.environments : merge(local.application_defaults, local.application_defaults.environments[envk], appv, envv, {
        app = appk
        env = envk
        environments = null # an environment should not have visibility to the other environments of its app
      })
    ]
  ]) : "${ae.app}-${ae.env}" => ae }
}
