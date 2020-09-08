provider "azurerm" {
  features{}
  version = "2.21.0"
 }

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "aue-rg-Terraform"
    location = var.location["prod"]
}
#create Azure VNET
resource "azurerm_virtual_network" "test" {
    name = "tf-vnetaue01"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space =["10.100.100.0/24"]
}
resource "azurerm_subnet" "vnetsubnet" {
    name = var.subnet[0]
    resource_group_name= azurerm_resource_group.rg.name
    virtual_network_name =azurerm_virtual_network.test.name
    address_prefixes = ["10.100.100.0/25"]
}
resource "azurerm_subnet" "vnetsubnet01" {
    name = var.subnet[1]
    resource_group_name= azurerm_resource_group.rg.name
    virtual_network_name =azurerm_virtual_network.test.name
    address_prefixes = ["10.100.100.128/25"]
}
variable "subnet" {
type =list
default = ["subnet01", "subnet02"]
}

variable "location" {
    type =  map
    default = {
        prod = "australiasoutheast"
        dr = "australiaeast"
    }
}
