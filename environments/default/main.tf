provider "google" {
  project = var.hostproject
}

# these are maps that would be used for creating as many subnets in given regions
# and reigonal nats/routers as defined in tfvars file
# it means that if you need more subnets, just add a few symbols in tfvars
locals {
  subnets = zipmap(var.subnetnames,var.cidrranges)
  subnetsregions = zipmap(var.subnetnames,var.regions)
  subnetswithnatsregions = zipmap(matchkeys(var.subnetnames,var.subnetnames,var.subnetswithnat),matchkeys(var.regions,var.subnetnames,var.subnetswithnat))
}
 
# create empty vpc  
module "vpc" {
  source  = "../../modules/vpc"
  hostproject = var.hostproject

}

# create subnets
module "subnetsforvpc" {
  source  = "../../modules/subnetsforvpc"
  hostproject = var.hostproject  
  subnets = local.subnets
  network = module.vpc.network
  regions = local.subnetsregions
}


# make the host project a host for shared vpc 
# it could be moved inside the next module call (project factory)
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.hostproject 
}

# create service project
module "project-factory"{
  source  = "../../modules/project-factory"
  hostproject = google_compute_shared_vpc_host_project.host.project #"${var.hostproject}"  
  serviceprojectname = var.serviceprojectname  
  serviceprojectid = var.serviceprojectid 
  subnetIDs = module.subnetsforvpc.subnetsIDs  
  org_id = var.org_id 
  service_folder_id = var.service_folder_id  
  billing_accnt_id = var.billing_accnt_id 
}

# firewall rule to allow internet access to vms with the corresponding tag
module "frwrulesallowinternet"{
  source  = "../../modules/frwrulesallowinternet"
  hostproject = google_compute_shared_vpc_host_project.host.project  
  allowinternet = var.allowinternet 
  network = module.vpc.network
}
# cloud nat for private vm - needed to get apache
module "cloud-nat" {
  source  = "../../modules/cloud-nat"
  for_each = local.subnetswithnatsregions
  network = module.vpc.network
  project_id =  google_compute_shared_vpc_host_project.host.project
  region     = each.value
  router     = "router-${each.key}"
  router_asn = "${sum([64514,index(var.subnetnames,each.key)])}" # making it unique
  subnetworks =each.key
}
# create public vms - means vm on sub1
module "publicvm" {
  source  = "../../modules/publicvm"
  serviceprojectid = var.serviceprojectid  
  sub1vms = var.sub1vms  
  machine_type = var.machine_type  
  zone = "${var.regions[0]}-a"  
  tags = var.allowinternet  
  subnetwork = var.subnetnames[0]  
}
# create private vm - means vm on sub3
module "privatevm" {
  source  = "../../modules/privatevm"
  serviceprojectid = var.serviceprojectid  
  sub3vms = var.sub3vms  
  machine_type = var.machine_type
  zone = "${var.regions[2]}-a"  
  subnetwork = "${var.subnetnames[2]}"
  backendtag = var.backendtag    
}

# the following few blocks show creation of network endpoint group
# adding vm from sub 3 to the network endpoint group and creating http load balancer
# it is suggested to replace vm+neg with just managed instance group - would require approval from client though
# the code below is not packed in modules - high chance of switching from vm+neg to mig
resource "google_compute_network_endpoint_group" "group" {
  name         = "my-lb-neg"
  network      =  "projects/${var.hostproject}/global/networks/${module.vpc.network}"
  project      =   "${var.serviceprojectid}"
  subnetwork   = module.subnetsforvpc.subnetsIDs[2]  
  default_port = "80"
  zone         = "${var.regions[2]}-a" 
}
resource "google_compute_network_endpoint" "endpoints" {
  count                 = length("${module.privatevm.names_and_ips}")  
  network_endpoint_group = google_compute_network_endpoint_group.group.name
  port       = google_compute_network_endpoint_group.group.default_port
  instance   = module.privatevm.names_and_ips[count.index][0]
  ip_address = module.privatevm.names_and_ips[count.index][1]
  zone         = "${var.regions[2]}-a" 
  project      =   "${var.serviceprojectid}"
}


# load balancer
module "gce-lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 4.4"
  target_tags       = [var.backendtag]
  project           = var.serviceprojectid  
  name              = "my-http-lb"
  firewall_projects = [var.hostproject]
  firewall_networks = [module.vpc.network]

  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = 80
      port_name                       = "http"
      timeout_sec                     = 10
      connection_draining_timeout_sec = 3600 # big number just in case things are slow to start
      enable_cdn                      = false
      security_policy                 = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      custom_request_headers          = null
      custom_response_headers         = null

    health_check = {  
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = 80
        host                = null
        logging             = null
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group                        =  google_compute_network_endpoint_group.group.self_link
          balancing_mode               = "RATE"
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = 10
          max_utilization              = null
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}

