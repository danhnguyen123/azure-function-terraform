variable "params" {}

variable "resource_group_name" {
    type = string
}

variable "resource_group_id" {
    type = string
}

variable "function_app_name" {
    type = string
}

variable "storage_account_name" {
    type = string
}

variable "env" {
    type = map(string)
    description = "(Optional) Environment variables."
    default = {}
}
