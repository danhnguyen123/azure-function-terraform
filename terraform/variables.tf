variable "project" {
  type = string
}

variable "location" {
  type = string
}

variable "function" {
  type = object({
      function_app_name = string
      storage_account_name = string
      env_vars = object({
        environment = string
        log_level = string
      })
      kv_secrets = object({
        product_name = string
      })
    })
}

variable "key_vault" {
  type = object({
      name = string
    })
}

variable "storage_account" {
  type = object({
      datalake = object({
        name = string
      })
      blob = object({
        name = string
      })
    })
}

variable "event_grid" {
  type = object({
      topic_name = string
      subscription_name = string
      function_name = string
    })
}