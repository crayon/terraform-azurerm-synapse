resource "azurerm_synapse_spark_pool" "pools" {
  for_each = { for sp in var.synapse_spark_pool : sp.name => sp }

  synapse_workspace_id = azurerm_synapse_workspace.main.id

  name                                = each.value.name
  node_size_family                    = each.value.node_size_family
  node_size                           = each.value.node_size
  node_count                          = each.value.node_count
  cache_size                          = each.value.cache_size
  spark_version                       = each.value.spark_version
  session_level_packages_enabled      = each.value.session_level_packages_enabled
  dynamic_executor_allocation_enabled = each.value.dynamic_executor_allocation_enabled

  auto_scale {
    max_node_count = each.value.auto_scale.max_node_count
    min_node_count = each.value.auto_scale.min_node_count
  }

  auto_pause {
    delay_in_minutes = each.value.auto_pause_delay_in_minutes
  }

  library_requirement {
    content  = each.value.library_requirement.content
    filename = each.value.library_requirement.filename
  }

  dynamic "spark_config" {
    for_each = each.value.spark_config != null ? ["spark_config"] : []
    content {
      content  = each.value.spark_config.content
      filename = each.value.spark_config.filename
    }
  }

  tags = var.tags

  # lifecycle {
  #   ignore_changes = [
  #     dynamic_executor_allocation_enabled
  #   ]
  # }
}
