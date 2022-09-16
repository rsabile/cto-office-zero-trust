resource "azurerm_storage_account" "webappsa01" {
  name                     = "${var.storage}${random_integer.random.result}"
  provider                 = azurerm.demo
  resource_group_name      = azurerm_resource_group.rg01.name
  location                 = azurerm_resource_group.rg01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    env    = "demo"
    client = var.client
  }
}

resource "azurerm_storage_container" "webappsablob01" {
  name                  = var.webappcontainer01
  provider              = azurerm.demo
  storage_account_name  = azurerm_storage_account.webappsa01.name
  container_access_type = "private"
}