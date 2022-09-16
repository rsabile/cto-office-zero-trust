resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  name                = "${var.prefix}-vnet-01"
  provider            = azurerm.demo
  address_space       = ["192.168.0.0/24"]
  tags = {
    env    = "demo"
    client = var.client
  }
}

resource "azurerm_subnet" "subnet" {
  provider             = azurerm.demo
  name                 = "subnet-project"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/25"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet_network_security_group_association" "nsgtosubnet01" {
  provider                  = azurerm.demo
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.vnetintegnsg01.id
}

resource "azurerm_private_dns_zone" "mysqldnsprivatezone" {
  name                = "privatelink.mysql.database.azure.com"
  provider            = azurerm.demo
  resource_group_name = azurerm_resource_group.rg01.name

  tags = {
    env    = "demo"
    client = var.client
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysqldnszonelink" {
  name                  = "mysqldnszonelink"
  provider              = azurerm.demo
  resource_group_name   = azurerm_resource_group.rg01.name
  private_dns_zone_name = azurerm_private_dns_zone.mysqldnsprivatezone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "pe-mysql" {
  name                = "pe-mysql"
  provider            = azurerm.demo
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "privateserviceconnection-mysql"
    private_connection_resource_id = azurerm_mysql_server.mysql-server01.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.mysqldnsprivatezone.id]
  }
  depends_on = [
    azurerm_mysql_server.mysql-server01
  ]
}

resource "azurerm_subnet" "integrationsubnet" {
  name                 = "integrationsubnet"
  provider             = azurerm.demo
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.128/25"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id = azurerm_windows_web_app.app01.id
  provider       = azurerm.demo
  subnet_id      = azurerm_subnet.integrationsubnet.id
}

/*
resource "azurerm_private_dns_zone" "webappdnsprivatezone" {
  name                = "privatelink.azurewebsites.net"
  provider            = azurerm.demo
  resource_group_name = azurerm_resource_group.rg01.name

  tags = {
    env    = "demo"
    client = "cto-day"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "webappdnszonelink" {
  name                  = "webappdnszonelink"
  provider              = azurerm.demo
  resource_group_name   = azurerm_resource_group.rg01.name
  private_dns_zone_name = azurerm_private_dns_zone.webappdnsprivatezone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}


resource "azurerm_private_endpoint" "privateendpoint" {
  name                = "pe-webapp"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  subnet_id           = azurerm_subnet.subnet.id

  private_dns_zone_group {
    name = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsprivatezone.id]
  }

  private_service_connection {
    name = "privateserviceconnection-webapp"
    private_connection_resource_id = azurerm_app_service.app01.id
    subresource_names = ["sites"]
    is_manual_connection = false
  }
}
*/
