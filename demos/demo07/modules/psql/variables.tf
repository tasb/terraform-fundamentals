variable "name" {
  description = "The name of the PostgreSQL server."
}

variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "location" {
  description = "The location of the database."
}

variable "admin_user" {
  description = "The administrator username for the PostgreSQL server."
}

variable "admin_password" {
  description = "The administrator password for the PostgreSQL server."
  sensitive   = true
}

variable "psql_version" {
  description = "The PostgreSQL version."
}

variable "zone" {
  description = "The availability zone."
}

variable "storage_mb" {
  description = "The storage capacity in MB."
}

variable "sku_name" {
  description = "The SKU of the PostgreSQL server."
}