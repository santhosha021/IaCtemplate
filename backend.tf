terraform {
  backend "azurerm" {
    storage_account_name = "terrafrombackendstore01"
    container_name       = "tf-store01"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "Ee2AyzPgfgpg=="
  }
}
