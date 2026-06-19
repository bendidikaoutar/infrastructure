variable "muestra_region" {
  description = "The aws region availability"
  type        = string
  default     = "Default Region"
}

variable "muestra_vpc_cidr" {
  type        = string
  description = "CIDR block of main VPC"
}

variable "muestra_subnet_cidr" {
  type        = string
  description = "CIDR block of the first subnet"
}

variable "worker_instance_type" {
  type        = string
  description = "Instance type for kubernetes nodes and master"
  default     = "t2.micro"
}

variable "master_instance_type" {
  type        = string
  description = "Instance type for kubernetes nodes and master"
  default     = "t2.micro"
}

variable "workers_count" {
  type        = number
  default     = 2
  description = "Number of Kubernetes worker nodes"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "Project Name"
}

variable "cloudflare_tunnel_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for muestra.qzz.io"
  type        = string
  sensitive   = true
}

variable "cloudflare_tunnel_id" {
  description = "Cloudflare Tunnel ID (UUID)"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "muestra_rds_subnet_cidr" {
  description = "CIDR pour le subnet secondaire RDS"
  type = string
}

variable "db_name" {
  type = string
  sensitive = true
}

variable "db_user" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}