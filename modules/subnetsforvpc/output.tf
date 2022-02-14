output "subnets" {
  value       = "${google_compute_subnetwork.subnetwork}"
  description = "The created subnets"
}
output "subnetsIDs" {
  value       = [for sub in "${google_compute_subnetwork.subnetwork}":sub.id]
  description = "The created subnet IDS"
}
