##
# All applications and their environments are defined in `local.applications`.
# They are flattened and denormalized into `local.application_environments`.
# From there, they are used to create all the boilerplate resources that allow
# application self-service.
##

locals {
  applications = {
    example = {
      cost_center = "88149" # default cost center for all environments
      environments = {
        development = {
          name   = "Example Development"
          branch = null
        }
      }
    }
  }

  application_defaults = {
    terraform_version = "1.0.1"
    environments = {
      development = null
      test        = "test"
      production  = "prod"
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