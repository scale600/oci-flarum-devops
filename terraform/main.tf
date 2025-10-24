# OCI Provider 설정
terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

# OCI Provider 구성
provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  region               = var.region
}

# 데이터 소스 - 가용성 도메인 정보
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# 데이터 소스 - 이미지 정보 (Oracle Linux 8)
data "oci_core_images" "oracle_linux" {
  compartment_id   = var.compartment_id
  operating_system = "Oracle Linux"
  operating_system_version = "8"
  shape            = "VM.Standard.E2.1.Micro"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
}

# VCN 생성
resource "oci_core_vcn" "flarum_vcn" {
  compartment_id = var.compartment_id
  display_name   = "flarum-vcn"
  cidr_blocks    = ["10.0.0.0/16"]
  dns_label      = "flarumvcn"
}

# 인터넷 게이트웨이
resource "oci_core_internet_gateway" "flarum_igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.flarum_vcn.id
  display_name   = "flarum-internet-gateway"
}

# 공용 서브넷
resource "oci_core_subnet" "flarum_public_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.flarum_vcn.id
  cidr_block          = "10.0.1.0/24"
  display_name        = "flarum-public-subnet"
  dns_label           = "flarumpublic"
  prohibit_public_ip_on_vnic = false
  route_table_id      = oci_core_route_table.flarum_public_route_table.id
  security_list_ids    = [oci_core_security_list.flarum_public_security_list.id]
}

# 프라이빗 서브넷 (데이터베이스용)
resource "oci_core_subnet" "flarum_private_subnet" {
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.flarum_vcn.id
  cidr_block          = "10.0.2.0/24"
  display_name        = "flarum-private-subnet"
  dns_label           = "flarumprivate"
  prohibit_public_ip_on_vnic = true
  route_table_id      = oci_core_route_table.flarum_private_route_table.id
  security_list_ids    = [oci_core_security_list.flarum_private_security_list.id]
}

# 공용 라우트 테이블
resource "oci_core_route_table" "flarum_public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.flarum_vcn.id
  display_name   = "flarum-public-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.flarum_igw.id
  }
}

# 프라이빗 라우트 테이블
resource "oci_core_route_table" "flarum_private_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.flarum_vcn.id
  display_name   = "flarum-private-route-table"
}

# 공용 보안 리스트
resource "oci_core_security_list" "flarum_public_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.flarum_vcn.id
  display_name   = "flarum-public-security-list"

  # SSH 접근 허용
  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min = 22
      max = 22
    }
  }

  # HTTP 접근 허용
  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min = 80
      max = 80
    }
  }

  # HTTPS 접근 허용
  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min = 443
      max = 443
    }
  }

  # 모든 아웃바운드 트래픽 허용
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless   = false
  }
}

# 프라이빗 보안 리스트 (데이터베이스용)
resource "oci_core_security_list" "flarum_private_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.flarum_vcn.id
  display_name   = "flarum-private-security-list"

  # MySQL 포트 (3306) - 공용 서브넷에서만 접근
  ingress_security_rules {
    protocol  = "6"
    source    = "10.0.1.0/24"
    stateless = false
    tcp_options {
      min = 3306
      max = 3306
    }
  }

  # 모든 아웃바운드 트래픽 허용
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless   = false
  }
}

# Compute 인스턴스 (Flarum 웹서버)
resource "oci_core_instance" "flarum_instance" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "flarum-web-server"
  shape               = "VM.Standard.E2.1.Micro"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.flarum_public_subnet.id
    display_name     = "flarum-vnic"
    assign_public_ip = true
    hostname_label   = "flarum"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/user_data.sh", {
      mysql_root_password = var.mysql_root_password
      mysql_database    = var.mysql_database
      mysql_user        = var.mysql_user
      mysql_password    = var.mysql_password
      flarum_public_ip  = "PLACEHOLDER_IP"
      domain_name       = var.domain_name
    }))
  }

  timeouts {
    create = "10m"
  }
}

# MySQL 데이터베이스 인스턴스 (프라이빗 서브넷)
resource "oci_core_instance" "mysql_instance" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "flarum-mysql-db"
  shape               = "VM.Standard.E2.1.Micro"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.flarum_private_subnet.id
    display_name     = "mysql-vnic"
    assign_public_ip = false
    hostname_label   = "mysql"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/mysql_user_data.sh", {
      mysql_root_password = var.mysql_root_password
      mysql_database      = var.mysql_database
      mysql_user          = var.mysql_user
      mysql_password      = var.mysql_password
    }))
  }

  timeouts {
    create = "10m"
  }
}
