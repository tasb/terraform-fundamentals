output "app_service_plan_id" {
  value = azurerm_service_plan.app_service_plan.id
}

output "web_app_ids" {
  value = { for name, app in azurerm_linux_web_app.web_app : name => app.id }
}