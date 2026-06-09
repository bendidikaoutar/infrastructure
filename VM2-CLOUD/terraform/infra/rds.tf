resource "aws_db_instance" "muestra_prod" {
  identifier = "muestra-prod"
  engine = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  storage_type = "gp2"
  storage_encrypted = true

  db_name = var.db_name
  username = var.db_user
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.muestra_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.muestra_cluster_sg.id]

  publicly_accessible = false
  multi_az = false
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "muestra-prod-final-snapshot"

  backup_retention_period = 0
  maintenance_window = "Mon:03:00-Mon:04:00"

  tags = { Name = "muestra-prod", Env = "prod" }
}