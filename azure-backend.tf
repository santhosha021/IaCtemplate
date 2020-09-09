terraform {
  backend "azurerm" {
    storage_account_name = "terrafrombackendstore01"
    container_name       = "tf-store01"
    key                  = "prod.terraform.tfstate"

    access_key = "EB="
  }
}
