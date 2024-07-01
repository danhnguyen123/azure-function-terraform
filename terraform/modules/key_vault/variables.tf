variable "params" {}

variable "resource_group_name" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "function_app_system_principal_id" {
  description = "The principal ID of the Function App"
  type        = string
  default = "value"
}
