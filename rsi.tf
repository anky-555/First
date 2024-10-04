terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
backend "azurerm" {
    resource_group_name  = ""  
    storage_account_name = ""                      
    container_name       = ""                      
    key                  = ""       
  }

}

provider "azurerm" {
  features { }
}

resource "azurerm_resource_group" "RSI_RG_TF" {
  name     = "RSI_RG_TF"
  location = "westus"
}

resource "azurerm_storage_account" "rsisatf" {
  depends_on               = [azurerm_resource_group.RSI_RG_TF]
  name                     = "rsisatf"
  location                 = "westus"
  resource_group_name      = "RSI_RG_TF"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_container" "rsicotf" {
  depends_on = [ azurerm_storage_account.rsisatf ]
  name                  = "rsicotf"
  storage_account_name  = "rsisatf"
  container_access_type = "private"
}


resource "azurerm_virtual_network" "rsivntf" {
  depends_on = [ azurerm_resource_group.RSI_RG_TF ]
  name                = "rsivntf"
  location            = "westus"
  resource_group_name = "RSI_RG_TF"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "frontend" {
 depends_on = [ azurerm_virtual_network.rsivntf ]
  name                 = "frontend"
  resource_group_name  = "RSI_RG_TF"
  virtual_network_name = "rsivntf"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  depends_on = [ azurerm_virtual_network.rsivntf ]
  name                 = "backend"
  resource_group_name  = "RSI_RG_TF"
  virtual_network_name = "rsivntf"
  address_prefixes     = ["10.0.2.0/24"]
}
