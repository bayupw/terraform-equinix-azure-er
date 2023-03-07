output "azurerm_subnet" {
  value       = var.create_gateway_subnet ? azurerm_subnet.this[0] : null
}

output "azurerm_public_ip" {
  value       = var.create_vng ? azurerm_public_ip.this[0] : null
}

output "azurerm_virtual_network_gateway" {
  value       = var.create_vng ? azurerm_public_ip.this[0] : null
}

output "azurerm_express_route_circuit" {
  value       = azurerm_express_route_circuit.this
}

output "azurerm_express_route_circuit_peering" {
  value       = var.create_circuit_peering ? azurerm_express_route_circuit_peering.this[0] : null
}

output "equinix_ecx_l2_connection" {
  value       = equinix_ecx_l2_connection.azure
}

output "azurerm_virtual_network_gateway_connection" {
  value       = var.create_circuit_peering ? azurerm_virtual_network_gateway_connection.this[0] : null
}