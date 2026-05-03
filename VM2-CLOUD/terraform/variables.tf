variable "aws_region" {
  description = "The aws region availability"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "muestra-ghaliani"
}

variable "instance_type" {
  description = "The instance type we will use"
  type        = string
  default     = "t3.micro"
}

variable "my_ip" {
  type = string
}