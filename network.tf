#############################################################################

# VARIABLES

#############################################################################

variable “resource_group_name” {

  type = string

}

provider “azurerm” {

  version = “=2.0.0”

  features {}

}

resource “azurerm_resource_group” “rg” {

  name     = var.resource_group_name

  location = “Australia East”

}

# Create a virtual network within the resource group

resource “azurerm_virtual_network” “terraform” {

  name                = “terraform-network”

  resource_group_name = azurerm_resource_group.rg.name

  location            = azurerm_resource_group.rg.location

  address_space       = [“10.10.0.0/24”]

}

resource “azurerm_subnet” “app-subnet” {

  name                 = “appsubnet01”

  resource_group_name  = azurerm_resource_group.rg.name

  virtual_network_name = azurerm_virtual_network.terraform.name

  address_prefix       = “10.10.0.0/25”

}
