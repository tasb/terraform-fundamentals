variable "name" {
  description = "The name of the virtual network."
}

variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "location" {
  description = "The location of the virtual network."
}

variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "subnets" {
  description = "A map of subnets to create."
  type        = list(object({
    name = string
    cidr = string
  }))
}