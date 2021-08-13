// Created by Gleb Otochkin 2020-06-26
#Provider and authentication details

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

module "network_security" {
  source = "./modules/network-security"
  vcn_id = oci_core_vcn.wp_vcn_1.id
  compartment_ocid = var.compartment_ocid
  security_list_id = oci_core_vcn.wp_vcn_1.default_security_list_id
  cidr_lb_subnet = var.cidr_lb_subnet
}