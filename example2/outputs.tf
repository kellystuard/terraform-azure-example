output "container_public_ip" {
  description = "Public IP of Container Application"
  value = azurerm_container_app.example.outbound_ip_addresses
}