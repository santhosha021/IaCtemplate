provider "azurerm" {
  features{}
  #version = "2.21.0"
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-aue-Terraform01"
    location = var.location["prod"]
    }

resource "azurerm_storage_account" "stracc" {
  name = var.straccname[count.index]
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier    = "Standard"
  account_replication_type = "LRS"
  count=2
}

variable "straccname" {
type =list
default = ["devstoracc01", "prodstoracc02"]
}

variable "location" {
    type =  map
    default = {
        prod = "australiasoutheast"
        dr = "australiaeast"
    }
}
