output "vm01_public_ip" {
  value = yandex_compute_instance.vm01_public.network_interface.0.nat_ip_address
}