provider "azurerm" {
  features{}
  version = "2.21.0"
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "aue-rg-Terraform"
    location = "australiaeast"
}
#create Azure VNET
resource "azurerm_virtual_network" "test" {
    name = "tf-vnetaue01"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space =["10.100.100.0/24"]
}
resource "azurerm_subnet" "vnetsubnet" {
    name = "workload01"
    resource_group_name= azurerm_resource_group.rg.name
    virtual_network_name =azurerm_virtual_network.test.name
    address_prefixes = ["10.100.100.0/25"]
}
resource "azurerm_network_interface" "nic01" {
  name                = "demo-nic01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnetsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "nsg01" {
  name                = "workload-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}
