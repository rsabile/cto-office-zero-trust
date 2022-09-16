resource "azurerm_log_analytics_workspace" "lawksp01" {
  name                = "${var.workspace}-${random_integer.random.result}"
  provider            = azurerm.demo
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    env    = "demo"
    client = var.client
  }  
}