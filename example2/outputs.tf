output "container_public_ip" {
  description = "Public URL of Container Application"
  value       = azurerm_container_group.example.fqdn
}