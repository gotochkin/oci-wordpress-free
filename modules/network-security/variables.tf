#    Created by Gleb Otochkin 2021-07-29  #

# Terraform module variables for security lists and groups
variable "vcn_id" {
  description = "vcn id"
  type        = string
}

variable "compartment_ocid" {
  description = "compartment id"
  type        = string
}

variable "security_list_id" {
  description = "ocid for the security list"
  type        = string
}

variable "cidr_lb_subnet" {
  type = string
}