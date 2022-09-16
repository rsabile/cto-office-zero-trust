resource "azurerm_resource_group" "rg01" {
  name     = "${var.rg}-${random_integer.random.result}"
  provider = azurerm.demo
  location = var.location
  tags = {
    env    = "demo"
    client = var.client
  }
}
