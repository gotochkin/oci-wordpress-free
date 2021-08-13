#    Created by Gleb Otochkin 2021-08-13  #

#Wordpress web  Network Security Group

resource "oci_core_network_security_group" "wp_network_security_group" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = var.vcn_id
    display_name = "WP-NSG"
}

# HTTP Security Group Rules
resource "oci_core_network_security_group_security_rule" "wp_nsg_rule_01" {
    #Required
    network_security_group_id = oci_core_network_security_group.tnsnet_network_security_group.id
    direction = "INGRESS"
    protocol = 6
    #Optional
    description = "HTTP access"
    source = var.cidr_lb_subnet
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
resource "oci_core_network_security_group_security_rule" "wp_nsg_rule_01" {
    #Required
    network_security_group_id = oci_core_network_security_group.tnsnet_network_security_group.id
    direction = "INGRESS"
    protocol = 6
    #Optional
    description = "HTTPS access"
    source = var.cidr_lb_subnet
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
