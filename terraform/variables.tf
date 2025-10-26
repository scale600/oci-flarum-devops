# OCI Authentication Information
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

# SSH Key Configuration
variable "ssh_public_key" {
  description = "SSH Public Key for instance access"
  type        = string
}

# MySQL Database Configuration
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


# Tag Configuration
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
