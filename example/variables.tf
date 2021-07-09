variable "location" {
  type    = string
  default = "North Central US"
}

variable "environment" {
  type = string
}

variable "cost_center" {
  type = string
}

variable "arm_subscription_id" {
  type    = string
  default = null
}

variable "arm_tenant_id" {
  type    = string
  default = null
}

variable "arm_client_id" {
  type    = string
  default = null
}

variable "arm_client_secret" {
  type    = string
  default = null
}