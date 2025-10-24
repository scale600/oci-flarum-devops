# Flarum 웹서버 정보
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

# MySQL 데이터베이스 정보
output "mysql_instance_private_ip" {
  description = "Private IP address of MySQL instance"
  value       = oci_core_instance.mysql_instance.private_ip
}

output "mysql_instance_ocid" {
  description = "OCID of MySQL instance"
  value       = oci_core_instance.mysql_instance.id
}

# 네트워크 정보
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

# 접속 정보
output "flarum_url" {
  description = "Flarum site URL"
  value       = "http://${oci_core_instance.flarum_instance.public_ip}"
}

output "ssh_connection_command" {
  description = "SSH connection command for Flarum instance"
  value       = "ssh opc@${oci_core_instance.flarum_instance.public_ip}"
}

# 설정 정보
output "mysql_connection_info" {
  description = "MySQL connection information"
  value = {
    host     = oci_core_instance.mysql_instance.private_ip
    port     = 3306
    database = var.mysql_database
    username = var.mysql_user
  }
  sensitive = true
}

# 리소스 요약
output "resource_summary" {
  description = "Summary of created resources"
  value = {
    flarum_instance = {
      name        = oci_core_instance.flarum_instance.display_name
      public_ip   = oci_core_instance.flarum_instance.public_ip
      shape       = "VM.Standard.A1.Flex (2 OCPU, 12GB RAM)"
    }
    mysql_instance = {
      name        = oci_core_instance.mysql_instance.display_name
      private_ip  = oci_core_instance.mysql_instance.private_ip
      shape       = "VM.Standard.A1.Flex (1 OCPU, 6GB RAM)"
    }
    network = {
      vcn_id           = oci_core_vcn.flarum_vcn.id
      public_subnet    = oci_core_subnet.flarum_public_subnet.cidr_block
      private_subnet   = oci_core_subnet.flarum_private_subnet.cidr_block
    }
  }
}
