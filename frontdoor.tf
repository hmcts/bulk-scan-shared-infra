resource "azurerm_frontdoor" "example" {
  name                                         = "${var.product}-${var.env}-frontdoor"
  location                                     = "${var.location}"
  resource_group_name                          = "${azurerm_resource_group.rg.name}"
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "exampleRoutingRule1"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["exampleFrontendEndpoint1"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "exampleBackendBing"
    }
  }

  backend_pool_load_balancing {
    name = "exampleLoadBalancingSettings1"
  }

  backend_pool_health_probe {
    name = "exampleHealthProbeSetting1"
  }

  backend_pool {
    name = "exampleBackendBing"
    backend {
      host_header = "www.bing.com"
      address     = "www.bing.com"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "exampleLoadBalancingSettings1"
    health_probe_name   = "exampleHealthProbeSetting1"
  }

  frontend_endpoint {
    name                              = "exampleFrontendEndpoint1"
    host_name                         = "example-FrontDoor.azurefd.net"
    custom_https_provisioning_enabled = false
  }
}

resource "azurerm_frontdoor_firewall_policy" "wafpolicy" {
  name                              = "bulkscan${replace(var.env, "-", "")}wafpolicy"
  resource_group_name               = "${azurerm_resource_group.rg.name}"
  enabled                           = true
  mode                              = "Prevention"

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }
  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
  }
}
