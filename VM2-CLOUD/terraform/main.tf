terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "muestra_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = var.project_name
  }
}

resource "aws_subnet" "muestra_subnet" {
  vpc_id                  = aws_vpc.muestra_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "muestra_gateway" {
  vpc_id = aws_vpc.muestra_vpc.id
}

resource "aws_route_table" "muestra_route_table" {
  vpc_id = aws_vpc.muestra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.muestra_gateway.id
  }
}

resource "aws_route_table_association" "muestra_route_table_association" {
  subnet_id      = aws_subnet.muestra_subnet.id
  route_table_id = aws_route_table.muestra_route_table.id
}

resource "aws_security_group" "muestra_security_group" {
  name        = "${var.project_name}-sg"
  description = "Security group for ${var.project_name}"
  vpc_id      = aws_vpc.muestra_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }

  ingress {
    description = "Backend port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Frontend port"
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "vm2_ec2" {
  ami                    = "ami-04c332520bd9cedb4"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.muestra_subnet.id
  vpc_security_group_ids = [aws_security_group.muestra_security_group.id]
  key_name               = "muestra-key"
  tags = {
    Name = "${var.project_name}-server"
  }
}