#    Created by Gleb Otochkin 2021-08-13  #

#Network Security Group for Web access (can be used for a Load balancer)
#  Web access security group
resource "oci_core_network_security_group" "web_access_security_group" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = var.vcn_id
    display_name = "WebAccess-NSG"
}

# HTTP Security Group Rules
resource "oci_core_network_security_group_security_rule" "web_access_nsg_rule_01" {
    #Required
    network_security_group_id = oci_core_network_security_group.web_access_network_security_group.id
    direction = "INGRESS"
    protocol = 6
    #Optional
    description = "HTTP access"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    tcp_options {
        #Optional
        destination_port_range {
            #Required
            max = 80
            min = 80
        }
    }
}

# HTTPS Security Group Rules
resource "oci_core_network_security_group_security_rule" "web_access_nsg_rule_02" {
    #Required
    network_security_group_id = oci_core_network_security_group.web_access_network_security_group.id
    direction = "INGRESS"
    protocol = 6
    #Optional
    description = "HTTPS access"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    tcp_options {
        #Optional
        destination_port_range {
            #Required
            max = 443
            min = 443
        }
    }
}