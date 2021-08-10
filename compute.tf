// Created by Gleb Otochkin 2021-06-12
//Wordpress compute
resource "oci_core_instance" "wp_instance" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "wordpress-a1"
  shape               = var.compute_shape
  	shape_config {
		memory_in_gbs = var.compute_shape_memory
		ocpus = var.compute_shape_cpu
	}

  create_vnic_details {
    subnet_id        = oci_core_subnet.wp_vcn_1_subnet_priv.id
    display_name     = "Primaryvnic"
    assign_public_ip = false
    hostname_label   = "wordpress-a1"
  }
  /* create_vnic_details {
    subnet_id        = oci_core_subnet.wp_vcn_1_subnet_pub.id
    display_name     = "Secondaryvnic"
    assign_public_ip = true
    hostname_label   = "wordpress-a1"
  }
*/
  source_details {
    source_type = "image"
    source_id   = var.image_id[var.region]
  }
  provisioner "file" {
    connection {
      agent       = false
      timeout     = "10m"
      host        = oci_core_instance.wp_instance.public_ip
      user        = "opc"
      private_key = var.ssh_private_key
    }
    source      = "data/wp_install.sh"
    destination = "/home/opc/wp_install.sh"
  }
provisioner "remote-exec" {
  connection {
      agent       = false
      timeout     = "10m"
      host        = oci_core_instance.wp_instance.public_ip
      user        = "opc"
      private_key = var.ssh_private_key
    }
    inline = [
      "chmod +x /home/opc/wp_install.sh"
    ]
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(file("./data/wordpress.cloud-config.yml"))
  }

  timeouts {
    create = "60m"
  }
}