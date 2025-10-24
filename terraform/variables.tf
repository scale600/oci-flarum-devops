# OCI 인증 정보
variable "tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "OCI User OCID"
  type        = string
}

variable "fingerprint" {
  description = "OCI API Key Fingerprint"
  type        = string
}

variable "private_key_path" {
  description = "Path to OCI API Key Private Key"
  type        = string
  default     = "~/.oci/oci_api_key.pem"
}

variable "region" {
  description = "OCI Region"
  type        = string
  default     = "ap-seoul-1"
}

variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

# SSH 키 설정
variable "ssh_public_key" {
  description = "SSH Public Key for instance access"
  type        = string
}

# MySQL 데이터베이스 설정
variable "mysql_root_password" {
  description = "MySQL root password"
  type        = string
  sensitive   = true
}

variable "mysql_database" {
  description = "MySQL database name for Flarum"
  type        = string
  default     = "flarum"
}

variable "mysql_user" {
  description = "MySQL user for Flarum"
  type        = string
  default     = "flarum"
}

variable "mysql_password" {
  description = "MySQL password for Flarum user"
  type        = string
  sensitive   = true
}

# Flarum 설정
variable "flarum_admin_email" {
  description = "Flarum admin email"
  type        = string
  default     = "admin@riderwin.com"
}

variable "flarum_admin_username" {
  description = "Flarum admin username"
  type        = string
  default     = "admin"
}

variable "flarum_admin_password" {
  description = "Flarum admin password"
  type        = string
  sensitive   = true
}

# 도메인 설정
variable "domain_name" {
  description = "Domain name for Flarum site"
  type        = string
  default     = "community.riderwin.com"
}

# 태그 설정
variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "flarum-community"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
