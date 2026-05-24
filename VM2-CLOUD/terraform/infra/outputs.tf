output "worker_private_ips" {
  value = aws_instance.k8_node[*].private_ip
}

output "worker_names" {
  value = [for i, node in aws_instance.k8_node : "muestra-node-${i + 1}"]
}