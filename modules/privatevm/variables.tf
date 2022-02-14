variable "serviceprojectid" {
  description = "Service project ID"
}

variable "sub3vms" {
    description = "Private vm(s) on sub3"
}

variable "machine_type"{
    description = "Machine type"
}

variable "zone"{
    description = "Zone"
}

variable "subnetwork"{
    description = "subnet for vm"
}

variable "backendtag"{
    description = "backend for firewall tag"
}
