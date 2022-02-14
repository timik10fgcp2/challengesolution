# create private (means on sub3) vm
# please note that the module create as many vms as there are in var.sub3vms
# made this way to make testing of other (but similar) prototypes easier 
# for example putting a few vms on sub3 (and correspondingly in load balancer backend)
resource "google_compute_instance" "privatevms" {
  count                  = length(var.sub3vms)   
  project      = "${var.serviceprojectid}" 
  name         =  var.sub3vms[count.index]
  machine_type =  var.machine_type
  zone         = var.zone
  tags = [var.backendtag]

  metadata_startup_script = "${file("${path.module}/scripts/startup.sh")}" 
  boot_disk {
    initialize_params {
      image = "projects/rhel-cloud/global/images/rhel-8-v20220126"
      size = "20"
    }
  }
  
  network_interface { # network
    subnetwork = var.subnetwork
  }
  service_account {
    scopes = ["cloud-platform"]
  }
}
