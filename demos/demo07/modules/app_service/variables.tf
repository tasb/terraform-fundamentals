variable "plan_name" {
  description = "The name of the app service plan."
}

variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "location" {
  description = "The location of the app service."
}

variable "sku_name" {
  description = "The SKU of the app service plan."
}

variable "web_apps" {
  description = "A map of web apps to create."
  type        = map(object({
    name          = string
    dotnet_version = string
  }))
}