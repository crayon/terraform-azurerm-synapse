resource "azurerm_storage_account" "main" {
  name                     = var.storage_account.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account.account_tier
  account_replication_type = var.storage_account.account_replication_type

  account_kind = lower(var.storage_account.account_tier) == "premium" ? "BlockBlobStorage" : null

  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = var.storage_account.allow_nested_items_to_be_public

  is_hns_enabled = true

  tags = var.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "main" {
  for_each = toset(var.adls_filesystem)
  name     = each.value

  storage_account_id = azurerm_storage_account.main.id
}
