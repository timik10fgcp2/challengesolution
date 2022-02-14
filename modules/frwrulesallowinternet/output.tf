output "firewall_rule" {
  value = "${google_compute_firewall.allow-internet}"
  description = "created firewall rule"
}