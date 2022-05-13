resource "azurerm_synapse_workspace" "main" {
  name                = format("syn-%s", var.name)
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.main[var.adls_filesystem[0]].id

  sql_administrator_login          = var.sql_administrator.login
  sql_administrator_login_password = var.sql_administrator.password

  managed_virtual_network_enabled = true

  purview_id = var.purview_id


  dynamic "azure_devops_repo" {
    for_each = var.azure_devops_repo != null ? ["repo"] : []
    content {
      account_name = var.azure_devops_repo.account_name
      branch_name  = var.azure_devops_repo.branch_name
      #last_commit_id  = var.azure_devops_repo.last_commit_id
      project_name    = var.azure_devops_repo.project_name
      repository_name = var.azure_devops_repo.repository_name
      root_folder     = var.azure_devops_repo.root_folder
      tenant_id       = var.azure_devops_repo.tenant_id
    }
  }

  tags = var.tags
}

resource "azurerm_synapse_sql_pool" "main" {
  for_each             = { for sp in var.dedicated_sql_pool : sp.name => sp }
  name                 = each.value.name
  synapse_workspace_id = azurerm_synapse_workspace.main.id
  sku_name             = each.value.sku_name
  create_mode          = each.value.create_mode

  tags = var.tags

  depends_on = [
    azurerm_synapse_workspace.main
  ]
}

resource "azurerm_synapse_firewall_rule" "main" {
  for_each             = { for fr in var.synapse_firewall_rule : fr.name => fr }
  synapse_workspace_id = azurerm_synapse_workspace.main.id

  name             = each.value.name
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_synapse_role_assignment" "roles" {
  for_each = { for ra in var.role_assignment : ra.principal_id => ra }

  synapse_workspace_id = azurerm_synapse_workspace.main.id
  role_name            = each.value.role_name
  principal_id         = each.value.principal_id
}
