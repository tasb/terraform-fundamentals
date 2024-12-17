resource "azurerm_postgresql_flexible_server" "db" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.admin_user
  administrator_password = var.admin_password
  version                = var.psql_version
  zone                   = var.zone
  storage_mb             = var.storage_mb
  sku_name               = var.sku_name
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_rule" {
  name             = "AllowAllAzureServicesAndResourcesWithinAzureIps"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}