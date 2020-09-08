provider "azurerm" {
  features{}
  version = ">2.21.0"
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "aue-rg-Terraform01"
    location = var.location["prod"]
}
variable "env" {}

#create Azure VNET
resource "azurerm_virtual_network" "dr" {
    name = "tf-dev-vnetaue01"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space =["10.100.100.0/24"]
    count = var.env == true ? 1 : 0
}
#create Azure VNET
resource "azurerm_virtual_network" "prod" {
    name = "tf-prod-vnetaue01"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space =["10.100.101.0/24"]
    count = var.env == false ? 1 : 0
}

variable "location" {
    type =  map
    default = {
        prod = "australiasoutheast"
        dr = "australiaeast"
    }
}
