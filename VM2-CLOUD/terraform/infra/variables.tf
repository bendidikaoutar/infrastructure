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

variable "external_ip" {
  type        = string
  description = "Our external IP"
  default     = "0.0.0.0/0" # Default value set to allow all IPs
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

variable "tailscale_auth_key" {
  description = "Tailscale auth key"
  sensitive   = true
}

variable "cloudflare_tunnel_token" {
  type      = string
  sensitive = true
}