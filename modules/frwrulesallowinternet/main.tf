# add var.allowinternet tag based firewall rule
resource "google_compute_firewall" "allow-internet" {
  name    = "${var.network}-allow-internet"
  network = "${var.network}"
  project = "${var.hostproject}"
  direction = "INGRESS"
  # http and ssh
  allow {
    protocol = "tcp"
    ports    = ["22","80"]
  }
  # icmp is prety useful for testing - could have left it
  # allow {
  #  protocol = "icmp"
  # }
  priority = 1000
  target_tags   = ["${var.allowinternet}"]
  source_ranges = ["0.0.0.0/0"]
}