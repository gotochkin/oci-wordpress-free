#    Created by Gleb Otochkin 2021-07-29  #

# Output
output "wp_lb_network_security_group_id" {
  description = "wordpress_network_security_group ocid"
  value       = oci_core_network_security_group.wp_lb_network_security_group.id
}

output "web_access_security_group_id" {
  description = "web_access_security_group ocid"
  value       = oci_core_network_security_group.web_access_network_security_group.id
}