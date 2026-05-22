output "kubernetes_master_node_public_ip" {
  value = aws_instance.k8_master.public_ip
}

output "kubernetes_worker_nodes_public_ip" {
  value = {
    for instance in aws_instance.k8_node :
    instance.id => instance.public_ip
  }
}