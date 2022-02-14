terraform {
  backend "gcs" {
    bucket = "hostproject-341120-tfstate"
    prefix = "env/default"
 }
}