provider "azurerm" {
  features{}
  #version = "2.21.0"
   }

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-MyFirstTerraform01"
    location = "australiaeast"
}

resource "azurerm_storage_account" "stracc" {
  name = "azterraformstracc01"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier    = "Standard"
  account_replication_type = "LRS"
}

output "azstorageaccount" {
  value = azurerm_storage_account.stracc.primary_blob_endpoint
}
