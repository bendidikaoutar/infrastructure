output "master_private_ip" {
  value       = aws_instance.k8_master.private_ip
}

output "master_public_ip" {
  value = aws_instance.k8_master.public_ip 
}

output "worker_names" {
  value = aws_instance.k8_node[*].tags.Name
}

output "workers_private_ips" {
  value = aws_instance.k8_node[*].private_ip
}

output "workers_public_ips" {
  value = aws_instance.k8_node[*].public_ip
}

output "rds_prod_endpoint" {
  value = aws_db_instance.muestra_prod.endpoint
  description = "A mettre dans le secret GitHub DB_HOST"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.muestra_uploads.bucket
}

output "s3_access_key_id" {
  value     = aws_iam_access_key.muestra_backend.id
  sensitive = true
}

output "s3_secret_access_key" {
  value     = aws_iam_access_key.muestra_backend.secret
  sensitive = true
}