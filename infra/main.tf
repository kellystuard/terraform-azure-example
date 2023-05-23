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
          branch = null
        }
        tst = {
          name   = "Example 1 Test"
          branch = "test"
        }
      }
    }
    example2 = {
      cost_center = "58497" # default cost center for all environments
      environments = {
        dev = {
          name   = "Example 1 Development"
          branch = null
        }
        tst = {
          name   = "Example 1 Test"
          branch = "test"
        }
      }
    }
  }

  application_defaults = {
    terraform_version = "1.0.1"
    environments = {
      dev = null
      tst = "test"
      prd = "prod"
    }
  }

  application_environments = { for ae in flatten([
    for appk, appv in local.applications : [
      for envk, envv in appv.environments : merge(envv, {
        id = envk
        application = merge(appv, {
          id           = appk
          environments = null # an environment should not have visibility to other environments
        })
      })
    ]
  ]) : "${ae.application.id}-${ae.id}" => ae }
}
