# Flarum Web Server Information
output "flarum_instance_public_ip" {
  description = "Public IP address of Flarum instance"
  value       = oci_core_instance.flarum_instance.public_ip
}

output "flarum_instance_private_ip" {
  description = "Private IP address of Flarum instance"
  value       = oci_core_instance.flarum_instance.private_ip
}

output "flarum_instance_ocid" {
  description = "OCID of Flarum instance"
  value       = oci_core_instance.flarum_instance.id
}

# MySQL is integrated as Docker container

# Network Information
output "vcn_id" {
  description = "VCN OCID"
  value       = oci_core_vcn.flarum_vcn.id
}

output "public_subnet_id" {
  description = "Public subnet OCID"
  value       = oci_core_subnet.flarum_public_subnet.id
}

output "private_subnet_id" {
  description = "Private subnet OCID"
  value       = oci_core_subnet.flarum_private_subnet.id
}

# Connection Information
output "flarum_url" {
  description = "Flarum site URL"
  value       = "http://${oci_core_instance.flarum_instance.public_ip}"
}

output "ssh_connection_command" {
  description = "SSH connection command for Flarum instance"
  value       = "ssh opc@${oci_core_instance.flarum_instance.public_ip}"
}

# MySQL Connection Information (Docker Container)
output "mysql_connection_info" {
  description = "MySQL connection information (Docker container)"
  value = {
    host     = "localhost"
    port     = 3306
    database = var.mysql_database
    username = var.mysql_user
  }
  sensitive = true
}

# Resource Summary
output "resource_summary" {
  description = "Summary of created resources"
  value = {
    flarum_instance = {
      name        = oci_core_instance.flarum_instance.display_name
      public_ip   = oci_core_instance.flarum_instance.public_ip
      shape       = "VM.Standard.E2.1.Micro (1 OCPU, 1GB RAM)"
    }
    mysql_container = {
      description = "MySQL running as Docker container on same instance"
      host        = "localhost"
      port        = 3306
    }
    network = {
      vcn_id           = oci_core_vcn.flarum_vcn.id
      public_subnet    = oci_core_subnet.flarum_public_subnet.cidr_block
      private_subnet   = oci_core_subnet.flarum_private_subnet.cidr_block
    }
  }
}
