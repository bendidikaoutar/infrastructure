resource "aws_key_pair" "muestra" {
  key_name = "muestra-key"
  public_key = file("~/.ssh/muestra.pub")
}

resource "aws_instance" "k8_master" {
  ami                         = "ami-02ab616bef07ac291" # Ubuntu 20.04
  instance_type               = var.master_instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.muestra_cluster_sg.id]
  subnet_id                   = aws_subnet.muestra_subnet.id
  user_data                   = base64encode(templatefile("./startup_master.sh",  {
    cloudflare_tunnel_token = var.cloudflare_tunnel_token
    hostname = "muestra-master"
  }))
  user_data_replace_on_change = true
  key_name = aws_key_pair.muestra.key_name

  tags = {
    Name = "muestra-master"
  }

  depends_on = [aws_main_route_table_association.muestra_set_rt_to_vpc]
}

resource "aws_instance" "k8_node" {
  count                       = var.workers_count
  ami                         = "ami-02ab616bef07ac291" # Ubuntu 20.04
  instance_type               = var.worker_instance_type
  associate_public_ip_address = true # It's better to use NAT GateWay but I don't have money for that
  vpc_security_group_ids      = [aws_security_group.muestra_cluster_sg.id]
  subnet_id                   = aws_subnet.muestra_subnet.id
  key_name = aws_key_pair.muestra.key_name

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = join("-", ["muestra-node", count.index + 1])
  }

  depends_on = [aws_main_route_table_association.muestra_set_rt_to_vpc]
}