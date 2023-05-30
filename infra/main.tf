##
# All applications and their environments are defined in `local.applications`.
# They are flattened and denormalized into `local.application_environments`.
# From there, they are used to create all the boilerplate resources that allow
# application self-service.
##

locals {
  applications = {
    example1 = {
      cost_center = "88149" # default cost center for all environments
      environments = {
        dev = {
          name   = "Example 1 Development"
        }
        tst = {
          name   = "Example 1 Test"
        }
      }
    }
    example2 = {
      cost_center = "58497" # default cost center for all environments
      environments = {
        dev = {
          name   = "Example 2 Development"
        }
        tst = {
          name   = "Example 2 Special Test" #special cost center for special test environment
          branch = "test-special"
          cost_center = "90000"
        }
      }
    }
  }

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
