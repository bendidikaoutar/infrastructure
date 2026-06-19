# Main subnet security gorup
resource "aws_security_group" "muestra_cluster_sg" {
  name        = "muestra_security_group"
  description = "Allows incoming SSH and outgoing to all ports"
  vpc_id      = aws_vpc.vpc_muestra.id

  egress {
    description = "Allows all ports to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Internal cluster traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.muestra_vpc_cidr]
  }
}

# RDS security group
resource "aws_security_group" "muestra_rds_sg" {
  name = "muestra-rds-sg"
  description = "Allow PostgreSQL from K8s cluster only"
  vpc_id = aws_vpc.vpc_muestra.id

  ingress {
    description = "PostgreSQL from K8s cluster"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.muestra_cluster_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = { Name = "muestra-rds-sg" }
}