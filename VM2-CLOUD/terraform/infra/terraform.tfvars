muestra_region        = "eu-west-3"
muestra_vpc_cidr      = "10.0.0.0/16"
muestra_subnet_cidr   = "10.0.1.0/24"
master_instance_type = "t3.small"
worker_instance_type  = "t3.micro"
workers_count         = 3
project_name          = "muestra-ghailani"

muestra_rds_subnet_cidr = "10.0.2.0/24"
db_name = "muestra_prod_database"
db_user = "muestra_admin"
db_password = "<db_password>"

 
cloudflare_tunnel_token = "<cldf_token>" 
cloudflare_account_id = "<cldf_id>"
cloudflare_zone_id = "<cldf_zone>"
cloudflare_tunnel_id = "<cldf_tunnel>"
cloudflare_api_token = "<api_token>"