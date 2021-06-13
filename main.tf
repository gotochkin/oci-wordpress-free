// Created by Gleb Otochkin 2020-06-26
#Provider and authentication details
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "db_system_shape" {
  default = "VM.Standard2.1"
}
variable "db_version" {
  default = "12.2.0.1"
}
variable "db_workload" {
  default = "OLTP"
}
variable "db_admin_password" {}
variable "data_storage_size_in_gb" {
  default = "256"
}
variable "db_disk_redundancy" {
  default = "NORMAL"
}
variable "db_edition" {
  default = "ENTERPRISE_EDITION"
}
variable "license_model" {
  default = "BRING_YOUR_OWN_LICENSE"
}
variable "db_hostname" {
  default =  "cloudhost01"
}
variable "zdm_image_ocid" {
  default =  "ocid1.image.oc1.ca-toronto-1.aaaaaaaarcxspevclfejaesgnsiowu4ovpp3gsrigpfchqwlt3ru7h5pbj3a"
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

variable "image_id" {
  type = map
  default = {
    // See https://docs.cloud.oracle.com/iaas/images/
    // Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    us-phoenix-1 = "ocid1.appcataloglisting.oc1..aaaaaaaaheuwo4wunrr4eqn6hab36sgeur5xb25nbs5v4f4w3cytjcqysurq"
    us-ashburn-1 = "ocid1.appcataloglisting.oc1..aaaaaaaaheuwo4wunrr4eqn6hab36sgeur5xb25nbs5v4f4w3cytjcqysurq"
    eu-frankfurt-1 = "ocid1.appcataloglisting.oc1..aaaaaaaaheuwo4wunrr4eqn6hab36sgeur5xb25nbs5v4f4w3cytjcqysurq"
    ca-toronto-1 = "ocid1.appcataloglisting.oc1..aaaaaaaaheuwo4wunrr4eqn6hab36sgeur5xb25nbs5v4f4w3cytjcqysurq"
  }
}
variable "database_image_ocid" {
  type = map(string)

  default = {
    # Marketplace image for Oracle Database 12.2.0.1 
    # Oracle-provided image 
    ca-toronto-1   = "ocid1.image.oc1..aaaaaaaagq6kmzvljgtehmusrxl6uu2x3h2owkek5bg2xrbwzk4smv45z2pa"
    us-ashburn-1   = "ocid1.image.oc1..aaaaaaaagq6kmzvljgtehmusrxl6uu2x3h2owkek5bg2xrbwzk4smv45z2pa"
    us-phoenix-1 = "ocid1.image.oc1..aaaaaaaagq6kmzvljgtehmusrxl6uu2x3h2owkek5bg2xrbwzk4smv45z2pa"
  }
}

data "oci_identity_compartment" "zdm_compartment" {
    #Required
    id = var.compartment_ocid
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}