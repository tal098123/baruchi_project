output "resource_group_name" {
  value = var.rg_tr_westus
}

output "private_ip_db" {
  value = azurerm_network_interface.az_nic_db.private_ip_address
}

output "public_ip_db" {
  value = azurerm_public_ip.az_pip_db
}