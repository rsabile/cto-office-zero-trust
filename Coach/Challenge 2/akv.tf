# # Create User Assigned Managed Identity
# resource "azurerm_user_assigned_identity" "uai01" {
#   resource_group_name = azurerm_resource_group.rg01.name
#   provider            = azurerm.demo
#   location            = azurerm_resource_group.rg01.location
#   name                = "ctoday-wpapp01"
# }

resource "azurerm_role_assignment" "akv01role" {
  scope                = azurerm_key_vault.akv01.id
  provider             = azurerm.demo
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_web_app.app01.identity[0].principal_id
}

resource "azurerm_role_assignment" "akv02role" {
  scope                = azurerm_key_vault.akv01.id
  provider             = azurerm.demo
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault" "akv01" {
  name                        = "${var.keyvault}-${random_integer.random.result}"
  provider                    = azurerm.demo
  location                    = azurerm_resource_group.rg01.location
  resource_group_name         = azurerm_resource_group.rg01.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  sku_name = "standard"

   tags = {
    env    = "demo"
    client = var.client
  }
}

resource "azurerm_key_vault_secret" "secret01" {
  name         = "mysql-secret01"
  provider     = azurerm.demo
  value        = "Database=${azurerm_mysql_database.mysql-db01.name}; Data Source=${azurerm_mysql_server.mysql-server01.name}.privatelink.mysql.database.azure.com; User Id=${var.mysql-admin-login}@${azurerm_mysql_server.mysql-server01.name}; Password=${var.mysql-admin-password}"
  key_vault_id = azurerm_key_vault.akv01.id

  depends_on = [
    azurerm_mysql_database.mysql-db01,
    azurerm_role_assignment.akv02role
  ]
}

# resource "azurerm_key_vault_access_policy" "akvap02" {
#   key_vault_id = azurerm_key_vault.akv01.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_user_assigned_identity

#   key_permissions = [
#     "Get", "List",
#   ]

#   secret_permissions = [
#     "Get", "List",
#   ]

#   depends_on = [
#     azurerm_app_service.app01
#   ]
# }