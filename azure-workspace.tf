#############################################################################
# VARIABLES
#############################################################################

variable "location" {
  type    = string
  default = "australiaeast"
}
variable "resource_group_name" {
  type = map(string)
  default = {
    dev  = "dev-aue-rg01"
    uat  = "uat-aue-rg01"
    prod = "prod-aue-rg01"
  }
}

variable "vnet_cidr_range" {
  type = map(string)
  default = {
    dev  = "10.2.0.0/16"
    uat  = "10.3.0.0/16"
    prod = "10.4.0.0/16"
  }
}
variable "vnet_name" {
  type = map(string)
  default = {
    dev  = "dev-vnet01"
    uat  = "uat-vnet01"
    prod = "prod-vnet01"
  }
}
variable "subnet_names" {
  type    = list(string)
  default = ["web", "database", "app"]

}

#############################################################################
# PROVIDERS
#############################################################################

provider "azurerm" {
  features {}
  subscription_id = "xxxxxxxxxxx-xxxxxxxxxxxxxx"
}

#############################################################################
# RESOURCES
#############################################################################

resource "azurerm_resource_group" "main" {
  name     =  var.resource_group_name[terraform.workspace]
  location = var.location

  tags = {
    environment = terraform.workspace
  }
}

data "template_file" "subnet_prefixes" {
  count = length(var.subnet_names)

  template = "$${cidrsubnet(vnet_cidr,8,current_count)}"

  vars = {
    vnet_cidr     = var.vnet_cidr_range[terraform.workspace]
    current_count = count.index
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name =  azurerm_resource_group.main.name
  vnet_name           =  var.vnet_name[terraform.workspace]
  address_space       = var.vnet_cidr_range[terraform.workspace]
  subnet_prefixes     = data.template_file.subnet_prefixes[*].rendered
  subnet_names        = var.subnet_names

  tags = {
    environment = terraform.workspace
    
  }
}

#############################################################################
# OUTPUTS
#############################################################################

output "vnet_id" {
  value = module.network.vnet_id
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}


