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

resource "azurerm_resource_group" "rg-net" {
  location = var.location
  name     = local.net_rg_name
  tags     = merge(local.tags, { type = "network" })
}

resource "azurerm_resource_group" "rg-app" {
  location = var.location
  name     = local.app_rg_name
  tags     = merge(local.tags, { type = "application" })
}

resource "azurerm_resource_group" "rg-db" {
  location = var.location
  name     = local.db_rg_name
  tags     = merge(local.tags, { type = "database" })
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = [var.vnet_cidr]
  location            = var.location
  name                = local.vnet_name
  resource_group_name = azurerm_resource_group.rg-net.name
}

resource "azurerm_subnet" "subnet" {
  for_each = { for s in var.subnets : s.name => s }

  address_prefixes     = [each.value.cidr]
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg-net.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = local.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg-app.name
  location            = azurerm_resource_group.rg-app.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "front_app" {
  name                = local.app_service_front_name
  resource_group_name = azurerm_resource_group.rg-app.name
  location            = azurerm_resource_group.rg-app.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
}

resource "azurerm_linux_web_app" "example" {
  name                = local.app_service_back_name
  resource_group_name = azurerm_resource_group.rg-app.name
  location            = azurerm_resource_group.rg-app.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
}

resource "azurerm_postgresql_flexible_server" "db" {
  name                   = local.db_server_name
  resource_group_name    = azurerm_resource_group.rg-db.name
  location               = azurerm_resource_group.rg-db.location
  version                = "14"
  administrator_login    = local.db_admin_user
  administrator_password = var.db_password
  zone                   = "1"

  storage_mb = 32768

  sku_name = "B_Standard_B1ms"
}

# Add firewall rule on your Azure Database for PostgreSQL server to allow other Azure services to reach it
resource "azurerm_postgresql_flexible_server_firewall_rule" "example" {
  name             = "AllowAllAzureServicesAndResourcesWithinAzureIps"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}


