output "terraform_random_string_result" {
  value = random_string.main.result
}

output "terraform_state_resource_group_name" {
  value = azurerm_resource_group.rg_backend.name
}
output "terraform_state_storage_account" {
  value = azurerm_storage_account.st_backend.name
}
output "terraform_state_storage_container_core" {
  value = azurerm_storage_container.tfstate.name
}