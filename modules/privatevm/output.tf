output "names_and_ips" {
  value       = [for vm in "${google_compute_instance.privatevms}": [vm.name,vm.network_interface.0.network_ip]]
  description = "The created vm(s)"
}
