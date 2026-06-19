# Main vpc
resource "aws_vpc" "vpc_muestra" {
  cidr_block           = var.muestra_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "muestra_vpc"
  }
}

resource "aws_internet_gateway" "igw_muestra" {
  vpc_id = aws_vpc.vpc_muestra.id
  tags = {
    Name = "muestra_vpc_igw"
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

# Private subnet
resource "aws_subnet" "muestra_subnet" {
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_muestra.id
  cidr_block        = var.muestra_subnet_cidr
  map_public_ip_on_launch = false
  tags = { Name = "muestra-private-subnet"}
}

resource "aws_route_table" "muestra_internet_route" {
  vpc_id = aws_vpc.vpc_muestra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_muestra.id
  }

  lifecycle {
    ignore_changes = all
  }

  tags = {
    Name = "muestra_route_table"
  }
}

resource "aws_main_route_table_association" "muestra_set_rt_to_vpc" {
  vpc_id         = aws_vpc.vpc_muestra.id
  route_table_id = aws_route_table.muestra_internet_route.id
}

# RDS subnet
resource "aws_subnet" "muestra_rds_subnet" {
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id = aws_vpc.vpc_muestra.id
  cidr_block = var.muestra_rds_subnet_cidr
  tags = { Name = "muestra-rds-subnet"}
}

resource "aws_db_subnet_group" "muestra_rds_subnet_group" {
  name = "muestra-rds-subnet-grup"
  subnet_ids = [
    aws_subnet.muestra_subnet.id,
    aws_subnet.muestra_rds_subnet.id,
  ]
  tags = { Name = "muestra-rds-subnet-group" }
}