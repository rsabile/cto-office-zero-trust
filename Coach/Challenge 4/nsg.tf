resource "azurerm_network_security_group" "vnetintegnsg01" {
  name                = "nsg-${random_integer.random.result}"
  provider            = azurerm.demo
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  tags = {
    env    = "demo"
    client = var.client
  }
}

resource "azurerm_network_security_rule" "nsgr01" {
    provider = azurerm.demo
  name                        = "nsg-${random_integer.random.result}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "192.168.0.0/24"
  destination_address_prefix  = "192.168.0.0/24"
  resource_group_name         = azurerm_resource_group.rg01.name
  network_security_group_name = azurerm_network_security_group.vnetintegnsg01.name
}
