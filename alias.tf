provider "azurerm" {
  features {}
  version         = ">2.21.0"
  subscription_id = "xxxxxx"
}

#create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-ause-Terraform01"
  location = "australiasoutheast"
  provider = "azurerm.santhosh"
}

resource "azurerm_storage_account" "stracc" {
  name                     = "azterraformstracc01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
#create resource group
resource "azurerm_resource_group" "rg1" {
  name     = "rg-aue-Terraform02"
  location = "australiaeast"
  provider = "azurerm.vsprofile"
}

# Create a virtual network within the resource group

resource "azurerm_virtual_network" "terraform" {

  name                = "terraform-network"
  resource_group_name = azurerm_resource_group.rg1.name
  location = azurerm_resource_group.rg1.location
  address_space = ["10.10.0.0/24"]
   provider = "azurerm.vsprofile"

}
