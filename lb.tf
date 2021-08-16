// Created by Gleb Otochkin 2021-06-12
//Wordpress VCN load balancer
resource "oci_load_balancer_load_balancer" "wp_lb_01" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "wp_lb_01"
  shape          = var.load_balancer_shape
  subnet_ids     = [oci_core_subnet.wp_vcn_1_subnet_lb.id]
  network_security_group_ids = [
    module.network_security.web_access_network_security_group_id
    ]
}

resource "oci_load_balancer_backend_set" "wp_lb_bk_set_01" {
  #Required
  health_checker {
    #Required
    protocol = "HTTP"

    #Optional
    port     = "80"
    url_path = "/readme.html"
    return_code = "200"
  }
  load_balancer_id = oci_load_balancer_load_balancer.wp_lb_01.id
  name             = "wp_lb_bk_set_01"
  policy           = "LEAST_CONNECTIONS"
}

resource "oci_load_balancer_backend" "wp_lb_bk_01" {
  #Required
  backendset_name  = oci_load_balancer_backend_set.wp_lb_bk_set_01.name
  ip_address       = oci_core_instance.wp_instance.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.wp_lb_01.id
  port             = "80"
}

resource "oci_load_balancer_listener" "wc_lb_lsnr_01" {
  #Required
  default_backend_set_name = oci_load_balancer_backend_set.wp_lb_bk_set_01.name
  load_balancer_id         = oci_load_balancer_load_balancer.wp_lb_01.id
  name                     = "wc_lb_lsnr_01"
  port                     = "80"
  protocol                 = "HTTP"
}

output wc_lb_01_load_balancer_IP {
  value = oci_load_balancer_load_balancer.wp_lb_01.ip_address_details[0]["ip_address"]
}