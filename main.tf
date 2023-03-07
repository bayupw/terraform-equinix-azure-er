resource "azurerm_subnet" "this" {
  count = var.create_gateway_subnet ? 1 : 0

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  name                 = "GatewaySubnet"
  address_prefixes     = var.gateway_subnet_cidr == null ? [local.azure_ergw_subnet] : [var.gateway_subnet_cidr]
}

resource "azurerm_public_ip" "this" {
  count = var.create_vng ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.azure_region
  name                = "${var.vng_name}-pip"
  sku                 = "Basic"
  allocation_method   = "Dynamic"
}

# Creating an ER gateway takes ~45-60 mins
resource "azurerm_virtual_network_gateway" "this" {
  count = var.create_vng ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.azure_region
  name                = var.vng_name
  type                = "ExpressRoute"

  sku           = var.vng_sku
  active_active = false
  enable_bgp    = false

  ip_configuration {
    name                          = "default"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.create_gateway_subnet ? azurerm_subnet.this[0].id : var.azurerm_subnet
    public_ip_address_id          = azurerm_public_ip.this[0].id
  }
}

resource "azurerm_express_route_circuit" "this" {
  resource_group_name   = var.resource_group_name
  name                  = var.er_circuit_name
  location              = var.azure_region
  service_provider_name = "Equinix"
  peering_location      = var.er_circuit_location
  bandwidth_in_mbps     = var.speed

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  allow_classic_operations = false
}

resource "azurerm_express_route_circuit_peering" "this" {
  count = var.create_circuit_peering ? 1 : 0

  resource_group_name           = var.resource_group_name
  express_route_circuit_name    = azurerm_express_route_circuit.this.name
  peering_type                  = "AzurePrivatePeering"
  peer_asn                      = var.router_asn
  primary_peer_address_prefix   = var.er_primary_address
  secondary_peer_address_prefix = var.er_secondary_address
  vlan_id                       = var.er_vlan_id
  shared_key                    = var.bgp_auth_key
}

data "equinix_ecx_l2_sellerprofile" "azure" {
  name = "Azure ExpressRoute"
}

resource "equinix_ecx_l2_connection" "azure" {
  name                = var.er_circuit_name
  profile_uuid        = data.equinix_ecx_l2_sellerprofile.azure.id
  speed               = var.speed
  speed_unit          = var.speed_unit
  notifications       = var.notifications
  device_uuid         = var.device_uuid
  device_interface_id = var.device_interface_id
  seller_region       = var.azure_region
  seller_metro_code   = var.metro_code
  authorization_key   = azurerm_express_route_circuit.this.service_key
  named_tag           = var.er_peering_type
  zside_vlan_ctag     = var.er_vlan_id

  timeouts {
    create = "10m"
    delete = "10m"
  }

  lifecycle {
    ignore_changes = [status]
  }

  depends_on = [azurerm_express_route_circuit.this]
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  count = var.create_circuit_peering ? 1 : 0

  resource_group_name        = var.resource_group_name
  location                   = var.azure_region
  name                       = "${var.vng_name}-connection"
  type                       = "ExpressRoute"
  virtual_network_gateway_id = var.create_vng ? azurerm_virtual_network_gateway.this[0].id : var.vng_id
  express_route_circuit_id   = azurerm_express_route_circuit.this.id

  timeouts {
    create = "20m"
    delete = "20m"
  }

  lifecycle {
    ignore_changes = all
  }
}

locals {
  azure_ergw_newbits = 27 - tonumber(split("/", var.azure_transit_cidr)[1])
  azure_ergw_netnum  = pow(2, local.azure_ergw_newbits)
  azure_ergw_subnet  = cidrsubnet(var.azure_transit_cidr, local.azure_ergw_newbits, local.azure_ergw_netnum - 2)
}