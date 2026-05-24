locals {
  cluster_hosts = jsonencode({
    master = {
      name     = "master.muestra.qzz.io"
      private_ip = aws_instance.k8_master.private_ip
    }
    workers = [
      for i in range(var.workers_count) : {
        name       = "worker${i + 1}.muestra.qzz.io"
        private_ip = aws_instance.k8_node[i].private_ip
        instance_name = aws_instance.k8_node[i].tags.Name
      }
    ]
  })
}

resource "local_file" "cluster_hosts" {
  content  = local.cluster_hosts
  filename = "${path.module}/cluster_hosts.json"
}