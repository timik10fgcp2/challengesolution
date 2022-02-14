# creates cloud + cloud router
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  network = "${var.network}" 
  project_id =  "${var.project_id}" 
  region     = "${var.region}" 
  create_router = true
  router     = "${var.router}" 
  router_asn = "${var.router_asn}" 
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetworks =[{
   name                    = "${var.subnetworks}", 
   source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
   secondary_ip_range_names = ["ALL_IP_RANGES"]
  }]
}
