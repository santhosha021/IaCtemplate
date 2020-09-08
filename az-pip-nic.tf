provider "azurerm" {
  features{}
  version = "2.21.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-test-tf01"
  location = "West US"
}

resource "azurerm_public_ip" "nic01" {
  name                = "az-pip01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
 }
 output "azurepip" {
     value = azurerm_public_ip.nic01
 }
