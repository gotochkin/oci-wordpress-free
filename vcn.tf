// Created by Gleb Otochkin 2021-06-12
//Wordpress VCN 

resource "oci_core_vcn" "wp_vcn_1" {
  cidr_block     = var.cidr_vcn
  dns_label      = "wpvcn1"
  compartment_id = var.compartment_ocid
  display_name   = "wp_vcn_1"
}

// A regional subnet will not specify an Availability Domain
//Public subnet
resource "oci_core_subnet" "wp_vcn_1_subnet_pub" {
  cidr_block        = var.cidr_pub_subnet
  display_name      = "wp_vcn_1_subnet_pub"
  dns_label         = "wpvcn1"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.wp_vcn_1.id
  //security_list_ids = [oci_core_vcn.wp_vcn_1.default_security_list_id]
  //route_table_id    = oci_core_vcn.wp_vcn_1.default_route_table_id
  //dhcp_options_id   = oci_core_vcn.wp_vcn_1.default_dhcp_options_id
}

//Private subnet
resource "oci_core_subnet" "wp_vcn_1_subnet_priv" {
  cidr_block        = var.cidr_priv_subnet
  display_name      = "wp_vcn_1_subnet_priv"
  dns_label         = "wpvcn1"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.wp_vcn_1.id
  //security_list_ids = [oci_core_vcn.wp_vcn_1.default_security_list_id]
  //route_table_id    = oci_core_vcn.wp_vcn_1.default_route_table_id
  //dhcp_options_id   = oci_core_vcn.wp_vcn_1.default_dhcp_options_id
}

//Load balancer subnet
resource "oci_core_subnet" "wp_vcn_1_subnet_lb" {
  cidr_block        = var.cidr_lb_subnet
  display_name      = "wp_vcn_1_subnet_lb"
  dns_label         = "wpvcn1"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.wp_vcn_1.id
  //security_list_ids = [oci_core_vcn.wp_vcn_1.default_security_list_id]
  //route_table_id    = oci_core_vcn.wp_vcn_1.default_route_table_id
  //dhcp_options_id   = oci_core_vcn.wp_vcn_1.default_dhcp_options_id
}

//Internet gateway
resource "oci_core_internet_gateway" "wp_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "wpInternetGateway"
  vcn_id         = oci_core_vcn.wp_vcn_1.id
}

//Local peering gateway
resource "oci_core_local_peering_gateway" "wp_vcn_1_lpgtw" {
  #Required
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.wp_vcn_1.id

  #Optional
  display_name = "wp_vcn_1_lpgtw"
  //peer_id      = oci_core_local_peering_gateway.test_local_peering_gateway_3_A.id
}

//Default route table 
resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.wp_vcn_1.default_route_table_id
  display_name               = "defaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.wp_internet_gateway.id
  }
  route_rules {
    destination       = "10.11.0.0/22"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_local_peering_gateway.wp_vcn_1_lpgtw.id
  }
}

//Default security list
resource "oci_core_default_security_list" "default_security_list" {
  manage_default_resource_id = oci_core_vcn.wp_vcn_1.default_security_list_id
  display_name               = "defaultSecurityList"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"         //tcp
  }

  // allow outbound udp traffic on a port range
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17"        // udp
    stateless   = true

    udp_options {
      min = 319
      max = 320
    }
  }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1         //icmp
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }
}