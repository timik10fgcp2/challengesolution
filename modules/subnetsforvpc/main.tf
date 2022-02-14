# creating subnets and putting them in corresponding regions
# change tfvars in  environments/default/ if you want more subnets/diferent regions
resource "google_compute_subnetwork" "subnetwork" {
  for_each                 = "${var.subnets}"
  name                     = each.key
  ip_cidr_range            = each.value
  region                   = lookup("${var.regions}",each.key,"us-west1")
  network                  = "${var.network}"
}