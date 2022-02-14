output "network" {
  value = "${module.vpc.network_name}"
  description = "A name of created VPC"
}
