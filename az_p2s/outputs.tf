output "account_id" {
  value = data.azurerm_client_config.current.tenant_id
}