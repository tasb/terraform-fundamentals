locals {
  net_rg_name            = "${var.prefix}-net-rg"
  app_rg_name            = "${var.prefix}-app-rg"
  db_rg_name             = "${var.prefix}-db-rg"
  vnet_name              = "${var.prefix}-vnet"
  app_service_plan_name  = "${var.prefix}-asp"
  app_service_front_name = "${var.prefix}-front-app"
  app_service_back_name  = "${var.prefix}-api-app"
  db_server_name         = "${var.prefix}-psql"
  db_admin_user          = "psqladmin"
  tags = {
    environment = "prod"
    owner       = var.prefix
  }
}

module "resource_group_network" {
  source   = "./modules/resource_group"
  name     = local.net_rg_name
  location = var.location
  tags     = merge(local.tags, { type = "network" })
}

module "resource_group_app" {
  source   = "./modules/resource_group"
  name     = local.app_rg_name
  location = var.location
  tags     = merge(local.tags, { type = "application" })
}

module "resource_group_db" {
  source   = "./modules/resource_group"
  name     = local.db_rg_name
  location = var.location
  tags     = merge(local.tags, { type = "database" })
}

module "network" {
  source              = "./modules/network"
  name                = local.vnet_name
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = module.resource_group_network.id
  subnets             = var.subnets
}

module "app_service" {
  source              = "./modules/app_service"
  plan_name           = local.app_service_plan_name
  resource_group_name = module.resource_group_app.id
  location            = var.location
  sku_name            = "B1"
  web_apps = {
    front_app = {
      name          = local.app_service_front_name
      dotnet_version = "8.0"
    }
    back_app = {
      name          = local.app_service_back_name
      dotnet_version = "8.0"
    }
  }
}

module "database" {
  source              = "./modules/database"
  name                = local.db_server_name
  resource_group_name = module.resource_group_db.id
  location            = var.location
  admin_user          = local.db_admin_user
  admin_password      = var.db_password
  version             = "14"
  zone                = "1"
  storage_mb          = 32768
  sku_name            = "B_Standard_B1ms"
}
