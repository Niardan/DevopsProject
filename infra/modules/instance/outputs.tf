output "internal_ip_address_server" {
  value = yandex_compute_instance.vm-server.network_interface[0].ip_address
}

output "external_ip_address_vm" {
  value = yandex_compute_instance.vm-server.network_interface[0].nat_ip_address
}