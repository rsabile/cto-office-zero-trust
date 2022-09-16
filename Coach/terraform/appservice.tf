
resource "azurerm_service_plan" "appPlan01" {
  name                = "${var.appplan}-${random_integer.random.result}"
  provider            = azurerm.demo
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  os_type             = "Windows"
  sku_name            = "S2"
  # zone_balancing_enabled = true

  tags = {
    env    = "demo"
    client = var.client
  }
}

resource "azurerm_windows_web_app" "app01" {
  name                = "${var.appservice}-${random_integer.random.result}"
  provider            = azurerm.demo
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  service_plan_id     = azurerm_service_plan.appPlan01.id

  https_only = true


  site_config {
    http2_enabled       = true
    minimum_tls_version = "1.2"
    default_documents   = ["index.php"]
    application_stack {
      current_stack = "php"
      php_version   = "7.4"
    }
  }

  connection_string {
    name  = azurerm_mysql_database.mysql-db01.name
    type  = "MySql"
    value = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.akv01.name};SecretName=${azurerm_key_vault_secret.secret01.name})"
    # value = "Database=${azurerm_mysql_database.mysql-db.name}; Data Source=${azurerm_mysql_server.mysql-server.name}.privatelink.mysql.database.azure.com; User Id=${var.mysql-admin-login}@${azurerm_mysql_server.mysql-server.name}; Password=${var.mysql-admin-password}"
    # value = "Database=${azurerm_mysql_database.mysql-db.name}; Data Source=${azurerm_mysql_server.mysql-server.name}.mysql.database.azure.com; User Id=${var.mysql-admin-login}@${azurerm_mysql_server.mysql-server.name}; Password=${var.mysql-admin-password}"
  }

  app_settings = {
    "WEBSITE_DNS_SERVER" : "168.63.129.16",
    "WEBSITE_VNET_ROUTE_ALL" : "1"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" : true
  }

  # identity {
  #   type         = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.uai01.id]
  # }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env    = "demo"
    client = var.client
  }
  depends_on = [
    azurerm_mysql_database.mysql-db01
    , azurerm_key_vault_secret.secret01
  ]
}

resource "azurerm_app_service_source_control" "wpcorp01" {
  app_id                 = azurerm_windows_web_app.app01.id
  provider               = azurerm.demo
  repo_url               = "https://github.com/azureappserviceoss/wordpress-azure"
  branch                 = "master"
  use_manual_integration = true
  # depends_on = [
  #   azurerm_windows_web_app.app01
  # ]
}

resource "azurerm_monitor_diagnostic_setting" "diaglogapp01" {
  name                       = "${var.prefix}-diag-app01"
  provider                   = azurerm.demo
  target_resource_id         = azurerm_windows_web_app.app01.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lawksp01.id

  # log {
  #   category = "Administrative"
  #   enabled  = true
  #   retention_policy {
  #     enabled = false
  #   }
  # }
  log {
    category = "AppServiceAuditLogs"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}
