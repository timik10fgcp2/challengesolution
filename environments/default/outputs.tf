output "network" {
  value = "${module.vpc.network}"
  description = "The created VPC"
}
output "subnets" {
  value       = [for sub in "${module.subnetsforvpc.subnets}":[sub.name,sub.ip_cidr_range,sub.region]]
  description = "The created subnet resources"
}

output "firewall_rule" {
  value = "${module.frwrulesallowinternet.firewall_rule.name}"
  description = "A name of created firewall rule"
}

output "serviceprojectid" {
  value = "${module.project-factory.serviceprojectid}"
  description = "ID of created service project"
}

output "cloudNAT" {
  value = [for nat in "${module.cloud-nat}":nat.name] 
  description = "A name of created NAT"
}

output "public_vm" {
  value = "${module.publicvm.names_and_ips}"
  description = "Names and public IPs"
}

output "private_vm" {
  value = "${module.privatevm.names_and_ips}"
  description = "Names and private IPs"
}

output "neg" {
  value = "${google_compute_network_endpoint_group.group.name}"
  description = "Network endpoint group"
}
output "neg_endpoints" {
  value = [for p in "${google_compute_network_endpoint.endpoints}": p.ip_address]
  description = "Network endpoint group endpoints"
}

output "load_balancer_ip" {
  value = "${module.gce-lb-http.external_ip}"
  description = "Load balancer"
}
