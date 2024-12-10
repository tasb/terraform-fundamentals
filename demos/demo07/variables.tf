variable "prefix" {
  description = "Prefix for all resources"
}

variable "location" {
  description = "Location for all resources"
  default     = "westeurope"
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network"
  default     = "10.20.30.0/24"
}

variable "subnets" {
  description = "CIDR block for the subnet"
  default = [{
    name = "app"
    cidr = "10.20.30.0/27"
    }, {
    name = "db"
    cidr = "10.20.30.32/27"
  }]
}

variable "db_password" {
  description = "Password for the database"
  sensitive   = true
}