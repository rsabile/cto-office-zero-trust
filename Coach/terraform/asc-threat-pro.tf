resource "azurerm_security_center_subscription_pricing" "ascp01" {
  tier          = "Standard"
  provider      = azurerm.demo
  resource_type = "KeyVaults"
  # depends_on = [
  #   azurerm_key_vault.akv01
  # ]
}

resource "azurerm_security_center_subscription_pricing" "ascp02" {
  tier          = "Standard"
  provider      = azurerm.demo
  resource_type = "AppServices"
}

resource "azurerm_security_center_subscription_pricing" "ascp03" {
  tier          = "Free"
  provider      = azurerm.demo
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_contact" "ascc01" {
  email = var.email
  provider = azurerm.demo
  
  alert_notifications = true
  alerts_to_admins    = true
}