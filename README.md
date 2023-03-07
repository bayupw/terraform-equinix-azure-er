# Terraform Equinix Fabric Azure Express Route

Terraform module for creating Azure Express Route via Equinix Fabric with options to create GatewaySubnet, VNG, and circuit peering.

To run this project, you will need to set the following environment variables or the [shared configuration and credentials files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
- EQUINIX_API_CLIENTID
- EQUINIX_API_CLIENTSECRET
- ARM_SUBSCRIPTION_ID  
- ARM_TENANT_ID
- ARM_CLIENT_ID
- ARM_CLIENT_SECRET

See the [Developer Platform](https://developer.equinix.com/docs?page=/dev-docs/fabric/overview) page on how to generate Client ID and Client Secret.

## Sample usage

```hcl
provider "azurerm" {
  features {}
}

module "azure-er" {
  source          = "bayupw/azure-er/equinix"
  version         = "1.0.1"

  azure_region             = "East US"
  er_circuit_location      = "New York"
  device_uuid              = "e5b3690f-fe79-45fc-8fcd-f4cb544b1bf4"
  device_interface_id      = 4
  er_circuit_name          = "azure-equinix-er"
  create_gateway_subnet    = true
  create_vng               = true
  resource_group_name      = "myRG"
  virtual_network_name     = "myVNet"
  azure_transit_cidr       = "10.0.0.0/23"
  vng_name                 = "myVng"
  create_circuit_peering   = true
  router_asn               = "65001"
  bgp_auth_key             = "Equinix123#"
}
```

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/bayupw/terraform-equinix-azure-er/issues/new) section.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/bayupw/terraform-equinix-azure-er/tree/master/LICENSE) for full details.