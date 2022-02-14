output "names_and_ips" {
  value       = [for vm in "${google_compute_instance.publicvms}": [vm.name,vm.network_interface.0.access_config.0.nat_ip]]
  description = "The created vm(s)"
}
