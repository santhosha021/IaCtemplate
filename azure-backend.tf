#############################################################################
# PROVIDERS
#############################################################################
provider "azurerm" {
  features {}
  version         = "2.21.0"
  subscription_id = "2040f397-6226-41ad-8425-ce61a75ac261"
}

variable "location" {
  type    = "string"
  default = "australia east"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-aue-tf01"
  location = "Australiaeast"
}

variable "rules" {
  type = list(map(string))
  default = [
    {
      name                       = "port_OB_443"
      priority                   = "200"
      direction                  = "outbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_ranges         = "*"
      destination_port_ranges    = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Inbound port443"
    },
    {
      name                       = "port_IB_443"
      priority                   = "200"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "tcp"
      source_port_ranges         = "*"
      destination_port_ranges    = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Oubound port443"
    }
  ]
}


resource "azurerm_network_security_group" "nsg" {
  name                = "test-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = [for s in var.rules : {
      name                       = s.name
      priority                   = s.priority
      direction                  = s.direction
      access                     = s.access
      protocol                   = s.protocol
      source_port_ranges         = split(",", replace(s.source_port_ranges, "*", "0-65535"))
      destination_port_ranges    = split(",", replace(s.destination_port_ranges, "*", "0-65535"))
      source_address_prefix      = s.source_address_prefix
      destination_address_prefix = s.destination_address_prefix
      description                = s.description
    }]
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_ranges         = security_rule.value.source_port_ranges
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      description                = security_rule.value.description
    }
  }
}
