// Created by Gleb Otochkin 2020-06-26
#Variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "compute_shape" {
  default = "VM.Standard.A1.Flex"
}
variable "compute_shape_memory" {
  default = "12"
}
variable "compute_shape_cpu" {
  default = "2"
}
variable "cidr_vcn" {
  default = "10.11.10.0/25"
}
variable "cidr_pub_subnet" {
  default = "10.11.10.0/27"
}
variable "cidr_priv_subnet" {
  default = "10.11.10.32/27"
}
variable "cidr_lb_subnet" {
  default = "10.11.10.64/27"
}
variable "mysql_root_password" {}
variable "load_balancer_shape" {
  default = "flexible"
}
variable "maximum_bandwidth_in_mbps" {
  default = "10"
}
variable "minimum_bandwidth_in_mbps" {
  default = "10"
}

variable "image_id" {
  type = map
  default = {
    // See https://docs.cloud.oracle.com/iaas/images/
    // Oracle-Linux-7.9-aarch64-2021.05.17-0"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaanohkqfajxmsdwcbbchbrccj3lhk7acahpnxt7usirbpo2o56sd7q"
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaaijzevirp67bdceiebqeg4epuqstqcogohn3gskw76ngxupke3zfa"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaajkxjdpgfzjl7tg3a7vzdvwnww6w5k47r5acwe4fqecowqwuoria"
    ca-toronto-1 = "ocid1.image.oc1.ca-toronto-1.aaaaaaaadc4exgz7ce2fwglv2od3dx3yjpj73yyaj3t4m2or4fssrtw5rtoa"
    uk-london-1 = "ocid1.image.oc1.uk-london-1.aaaaaaaaezfspur6d5z66jpu3znxm2z6civgqzgkfiwla35zzk4mcdlwsstq"
  }
}
