variable "metro_code" {
  description = "Metro location."
  type        = string
  default     = "NY"
}

variable "azure_region" {
  description = "Azure region."
  type        = string
  default     = "East US"
}

variable "er_circuit_location" {
  description = "Express Route circuit location."
  type        = string
  default     = "New York"
}

variable "create_gateway_subnet" {
  description = "Set to true to create a gateway subnet."
  type        = bool
  default     = true
}

variable "create_vng" {
  description = "Set to true to create a new virtual network gateway."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Existing resource group name."
  type        = string
}

variable "virtual_network_name" {
  description = "Existing VNet name."
  type        = string
}

variable "gateway_subnet_cidr" {
  description = "Custom gateway subnet CIDR."
  type        = string
  default     = null
}

variable "vng_id" {
  description = "Existing virtual network gateway id."
  type        = string
  default     = null
}

variable "vng_name" {
  description = "Virtual network gateway name."
  type        = string
  default     = "ergw"
}

variable "vng_sku" {
  description = "Virtual network gateway SKU."
  type        = string
  default     = "Standard"
}

variable "create_circuit_peering" {
  description = "Set to true to create circuit peering."
  type        = bool
  default     = true
}

variable "azurerm_subnet" {
  description = "Existing GatewaySubnet ID."
  type        = string
  default     = null
}

variable "er_circuit_name" {
  description = "Express Route circuit name."
  type        = string
  default     = "er-circuit"
}

variable "notifications" {
  description = "List of email addresses that will receive device status notifications."
  type        = list(string)
  default     = ["myemail@equinix.com"]
}

variable "device_interface_id" {
  description = "Equinix device interface ID."
  type        = number
  default     = 4
}

variable "router_asn" {
  description = "Router peer BGP AS Number."
  type        = string
  default     = "64513"
}

variable "bgp_auth_key" {
  description = "BGP authentication key."
  type        = string
  default     = "Equinix123#"
}

variable "azure_transit_cidr" {
  description = "Azure Transit Hub VNet CIDR."
  type        = string
  default     = "10.0.0.0/16"
}

variable "er_primary_address" {
  type        = string
  description = <<EOF
  A /30 subnet for the primary link. First usable IP address of the subnet should be assigned on the peered CE/PE-MSEE
  (Network Edge device or customer router). Microsoft will choose the second usable IP address of the subnet for the
  MSEE interface (cloud router).
  EOF
  default     = "169.254.255.252/30" // Usable IPs 169.254.255.253 - 169.254.255.254	
}

variable "er_secondary_address" {
  type        = string
  description = <<EOF
  A /30 subnet for the secondary link. First usable IP address of the subnet should be assigned on the peered
  CE/PE-MSEE (Network Edge device or customer router). Microsoft will choose the second usable IP address of the subnet
  for the MSEE interface (cloud router).
  EOF
  default     = "169.254.255.248/30" // Usable IPs 169.254.255.249 - 169.254.255.250	
}

variable "er_vlan_id" {
  type        = number
  description = "A valid VLAN ID to establish this peering on."
  default     = 500
}

variable "er_peering_type" {
  type        = string
  description = <<EOF
  The type of peering to set up in case when connecting to Azure Express Route. One of 'PRIVATE',
  'MICROSOFT'.
  EOF
  default     = "PRIVATE"

  validation {
    condition     = (contains(["PRIVATE", "MICROSOFT"], var.er_peering_type))
    error_message = "Valid values are (PRIVATE, MICROSOFT)."
  }
}

variable "speed" {
  description = "Azure ER speed."
  type        = string
  default     = "50"
}

variable "speed_unit" {
  description = "Azure ER speed unit."
  type        = string
  default     = "MB"
}

variable "device_uuid" {
  description = "Equinix device UUID."
  type        = string
}