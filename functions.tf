provider "azurerm" {
  features{}
  version = ">2.21.0"
   subscription_id="xxxxxxxxxxxxxxxxxxxxxx"
}
variable "prefix" {
  default = "azdemo-tf"
}
variable "vmname" {
    type = list
    default = ["az2016-vm01", "az-2019-vm01"]
}

variable "tags" {
    type = list
    default = ["windows2016", "windows2019"]
}
variable "sku" {
    type = list
    default = ["2016-Datacenter", "2019-Datacenter"]
}
locals {
    time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "Australiaeast"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["10.10.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "workload" {
  name                 = "workload"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.10.0.0/24"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.workload.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"
  count = 1

  delete_os_disk_on_termination = true

    delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = element(var.sku, count.index)
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = element(var.vmname,count.index)
    admin_username = "testadmin"
    admin_password = "Cloud@1234%&"
  }
  os_profile_windows_config { }
         tags = {
    "OS" = element(var.tags,count.index)
  }
  

}

output "timestamp" {
    value = local.time
}
