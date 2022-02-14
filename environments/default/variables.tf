variable "hostproject"  {
  description = "Host project"
}
variable "serviceprojectname" {
  description = "Service project"
}
variable "serviceprojectid" {
  description = "Service project ID"
}
variable "cidrranges" {
  description = "A list/tuple containing cidr ranges"
}
variable "subnetnames" {
  description = "A list/tuple of subnet names"
}
variable "regions" {
  description = "A list/tuple of subnet regions"
}
variable "allowinternet" {
    description = "tag to apply to instances that should be accessible through internet"
}
variable "org_id" {
    description = "Organization ID"
}
variable "service_folder_id" {
    description = "Application folder ID"
}
variable "billing_accnt_id" {
    description = "Billing account ID"
}

variable "subnetswithnat" {
    description = "Subnets that need NAT"
}

variable "sub1vms" {
    description = "Public vm(s) names on sub1"
}

variable "sub3vms" {
    description = "Private vm(s) names on sub3"
}
variable "machine_type"{
    description = "Machine type"
}
variable "backendtag"{
    description = "backend for firewall tag"
}
