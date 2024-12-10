output "db_id" {
  value = azurerm_postgresql_flexible_server.db.id
}

output "firewall_rule_id" {
  value = azurerm_postgresql_flexible_server_firewall_rule.firewall_rule.id
}