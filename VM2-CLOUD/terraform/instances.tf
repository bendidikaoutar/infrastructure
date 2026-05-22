resource "aws_key_pair" "ssh_key" {
  key_name   = "muestra-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "k8_master" {
  ami                         = "ami-02ab616bef07ac291" # Ubuntu 20.04
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.muestra_cluster_sg.id]
  subnet_id                   = aws_subnet.muestra_subnet.id
  user_data                   = filebase64("./scripts/startup-master.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "muestra-master"
  }

  depends_on = [aws_main_route_table_association.muestra_set_rt_to_vpc]
}

resource "aws_instance" "k8_node" {
  count                       = var.workers_count
  ami                         = "ami-02ab616bef07ac291" # Ubuntu 20.04
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.muestra_cluster_sg.id]
  subnet_id                   = aws_subnet.muestra_subnet.id
  user_data                   = filebase64("./scripts/startup-worker.sh")
  user_data_replace_on_change = true

  tags = {
    Name = join("-", ["muestra-node", count.index + 1])
  }

  depends_on = [aws_main_route_table_association.muestra_set_rt_to_vpc]
}