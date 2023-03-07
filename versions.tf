terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "~> 1.10.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.30.0"
    }
  }
}