data "aws_availability_zones" "az" {

}

module "network" {
  source = "./modules/network"

  env = terraform.workspace
  prefix = "main-network"
  cidr_block = "10.0.0.0/16"
  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]
  private_subnets = [
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/24",
  ]
  az = data.aws_availability_zones.az.names
}

module "web" {
  source = "./modules/web"

  env = terraform.workspace
  prefix = "web-app"
  ssh_sg_id = module.network.ssh_sg_id
  instance_type = var.instance_type
  subnets = module.network.public_subnet_ids
  vpc_id = module.network.vpc_id
}

module "db" {
  source = "./modules/db"

  env = terraform.workspace
  prefix = "web-app"
  instance_class = var.instance_class
  db_name = "main-db"
  db_username = var.db_username
  db_password = var.db_password
  private_subnets = module.network.private_subnet_ids
  sg_ssh_id = module.network.ssh_sg_id
  vpc_id = module.network.vpc_id
}

module "storage" {
  source = "./modules/storage"

  env = terraform.workspace
  prefix = "app-bucket"
  bucket_count = 5
}