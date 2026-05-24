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