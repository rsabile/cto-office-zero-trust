
resource "azurerm_service_plan" "appPlan01" {
  name                = "${var.appplan}-${random_integer.random.result}"
  provider            = azurerm.demo
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  os_type             = "Windows"
  sku_name            = "S2"

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
  }

  app_settings = {
    "WEBSITE_DNS_SERVER" : "168.63.129.16",
    "WEBSITE_VNET_ROUTE_ALL" : "1"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" : true
  }

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
}