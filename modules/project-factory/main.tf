# creating a service project and sharing vpc there
# activating compute api as well

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  name                 = "${var.serviceprojectname}"
  project_id           = "${var.serviceprojectid}"
  org_id               = "${var.org_id}"
  folder_id            =  "${var.service_folder_id}"
  billing_account      = "${var.billing_accnt_id}"
  svpc_host_project_id = "${var.hostproject}"
  # the line below is commented - we took care of this in environments/default/main.tf
  #enable_shared_vpc_host_project = true
  activate_apis         = [
    "compute.googleapis.com"
  ]
  shared_vpc_subnets = "${var.subnetIDs}"
}
