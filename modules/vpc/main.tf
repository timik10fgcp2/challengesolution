# just create an empty vpc
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "3.3.0"

  project_id   = "${var.hostproject}"
  network_name = "${var.hostproject}-network"
  subnets = [    
  ]
}