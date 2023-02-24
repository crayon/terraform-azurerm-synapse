output "synapse_sql_on_demand_endpoint" {
  description = "Connectivity endpoint for Synapse's on demand SQL pool."
  value       = azurerm_synapse_workspace.main.connectivity_endpoints.sqlOnDemand
}

output "synapse_workspace_id" {
  description = "Synapse workspace resource ID."
  value       = azurerm_synapse_workspace.main.id
}

output "synapse_workspace_mi_id" {
  description = "Principal ID of Synapse workspace's managed identity."
  value       = azurerm_synapse_workspace.main.identity[0].principal_id
}

output "storage_account_id" {
  description = "Data lake storage account resource ID."
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Data lake storage account resource name."
  value       = azurerm_storage_account.main.name
}

output "storage_account_connection_string_primary" {
  description = "Data lake storage account primary connection string."
  sensitive   = true
  value       = azurerm_storage_account.main.primary_connection_string
}
