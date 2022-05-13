variable "name" {
  description = "Name used for the deployment. All resources prefixed based on the Azure naming convention."
  type        = string
}

variable "resource_group_name" {
  description = "The resource group you want to deploy to."
  type        = string
}

variable "location" {
  description = "Location used for all resources."
  type        = string
}

variable "storage_account" {
  description = "Settings used when creating the Storage Account."
  type = object({
    name                     = string
    account_tier             = string
    account_replication_type = string
    allow_blob_public_access = bool
  })

  validation {
    condition     = length(var.storage_account.name) >= 3 && length(var.storage_account.name) <= 24
    error_message = "Storage account names must be between 3 and 24 characters long."
  }
}

variable "adls_filesystem" {
  description = "A list of Data Lake filesystems."
  type        = list(string)
  default     = ["data"]
}

variable "purview_id" {
  description = "The ID for the instance of Purview used with this Synapse workspace."
  type        = string
  default     = null
}

variable "sql_administrator" {
  description = "Username and password used for Synapse."
  type = object({
    login    = string
    password = string
  })
}

variable "dedicated_sql_pool" {
  description = "List of dedicated SQL pools."
  type = list(object({
    name        = string
    sku_name    = string
    create_mode = string
  }))
  default = []
}

variable "synapse_spark_pool" {
  description = "List of Synapse Spark pools."
  type = list(object({
    name                        = string
    node_size_family            = string
    node_size                   = string
    cache_size                  = number
    auto_pause_delay_in_minutes = number
    auto_scale = object({
      max_node_count = number
      min_node_count = number
    })
    library_requirement = object({
      content  = string
      filename = string
    })
    spark_config = object({
      content  = string
      filename = string
    })
  }))
  default = []
}

variable "azure_devops_repo" {
  description = "Definition of the Azure DevOps repository used with Synapse."
  type = object({
    account_name    = string
    branch_name     = string
    project_name    = string
    repository_name = string
    root_folder     = string
    tenant_id       = string
  })
  default = null
}

variable "synapse_firewall_rule" {
  description = "List of objects to create Synapse firewall rules."
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}

variable "role_assignment" {
  description = "A list of objects to to assign roles to the Synapse workspace."
  type = list(object({
    role_name    = string
    principal_id = string
  }))
  default = []
}

variable "tags" {
  description = "A map object used for all resources in the module."
  type        = map(string)
}
