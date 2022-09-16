resource "azurerm_frontdoor_firewall_policy" "demowafpolicy" {
  name                              = "wafpolicy"
  provider                          = azurerm.demo
  resource_group_name               = azurerm_resource_group.rg01.name
  enabled                           = true
  mode                              = "Prevention"
  custom_block_response_status_code = 403

  custom_block_response_body = "YmxvY2tlZCBieSBmcm9udGRvb3I="

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }
}

# resource "azurerm_frontdoor" "frontdoor1" {
#   name                                         = "${var.prefix}-afd01-${random_integer.random.result}"
#   provider                                     = azurerm.demo
#   resource_group_name                          = azurerm_resource_group.rg01.name
# #   enforce_backend_pools_certificate_name_check = false

#   routing_rule {
#     name               = "Rule1"
#     accepted_protocols = ["Https"]
#     patterns_to_match  = ["/*"]
#     frontend_endpoints = ["${var.prefix}-afd01-fe"]
#     forwarding_configuration {
#       forwarding_protocol                   = "HttpsOnly"
#       backend_pool_name                     = "Backend"
#       cache_enabled                         = true
#       cache_query_parameter_strip_directive = "StripNone"
#       cache_use_dynamic_compression         = true
#     }
#   }

#   backend_pool_load_balancing {
#     name = "LoadBalancingSettings1"

#   }

#   backend_pool_health_probe {
#     name     = "HealthProbeSetting1"
#     protocol = "Https"
#   }

#   backend_pool {
#     name = "Backend"
#     backend {
#       host_header = "${var.appservice}.azurewebsites.net"
#       address     = "${var.appservice}.azurewebsites.net"
#       http_port   = 80
#       https_port  = 443
#     }

#     load_balancing_name = "LoadBalancingSettings1"
#     health_probe_name   = "HealthProbeSetting1"
#   }

#   backend_pool_settings{
#     enforce_backend_pools_certificate_name_check = false
#   }

#   frontend_endpoint {
#     name                         = "${var.prefix}-afd01-fe"
#     host_name                    = "${var.prefix}-afd01-${random_integer.random.result}.azurefd.net"
#     session_affinity_enabled     = false
#     session_affinity_ttl_seconds = 0
#     //custom_https_provisioning_enabled = true
#     web_application_firewall_policy_link_id = azurerm_frontdoor_firewall_policy.demowafpolicy.id
#   }
# }

# ##### v2 support premium

resource "azurerm_cdn_frontdoor_profile" "afd02-profile" {
  name                = "afd02-profile"
  provider=azurerm.demo
  resource_group_name = azurerm_resource_group.rg01.name
  sku_name            = "Premium_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_origin_group" "afd02-origrp" {
  name                     = "afd02-origin-group"
  provider=azurerm.demo
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd02-profile.id

  load_balancing {}
}

resource "azurerm_cdn_frontdoor_origin" "afd02-orig" {
  name                          = "afd02-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd02-origrp.id
  provider=azurerm.demo

  health_probes_enabled          = true
  certificate_name_check_enabled = true
  host_name                      = "${var.appservice}.azurewebsites.net"
  origin_host_header             = "${var.appservice}.azurewebsites.net"
  priority                       = 1
  weight                         = 500

  private_link {
    request_message        = "Request access for Private Link Origin CDN Frontdoor"
    target_type            = "sites"
    location               = azurerm_windows_web_app.app01.location
    private_link_target_id = azurerm_windows_web_app.app01.id
  }
}

