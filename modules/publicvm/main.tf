# create public (means on sub1) vm
# please note that the module create as many vms as there are in var.sub1vms
# made this way to make testing of other (but similar) prototypes easier 
# for example putting a few vms on sub1
resource "google_compute_instance" "publicvms" {
  count                  = length(var.sub1vms)   
  project      = "${var.serviceprojectid}" 
  name         =  var.sub1vms[count.index]
  machine_type =  var.machine_type
  zone         = var.zone

  tags = [var.tags]

  boot_disk {
    initialize_params {
      image = "projects/rhel-cloud/global/images/rhel-8-v20220126"
      size = "20"
    }
  }
  
  network_interface { # network
    subnetwork = var.subnetwork
    access_config {
      // Ephemeral public IP
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }

}
