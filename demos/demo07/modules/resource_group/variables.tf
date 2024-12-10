variable "name" {
  description = "The name of the resource group."
}

variable "location" {
  description = "The location of the resource group."
}

variable "tags" {
  description = "Tags to assign to the resource group."
  type        = map(string)
}