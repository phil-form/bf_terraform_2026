module "network" {
  source = "./modules/network"

  env    = terraform.workspace
  cidr_block = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24"]
}

module "web" {
  source = "./modules/compute"

  sec_group_name = "web"
  env = terraform.workspace
  subnet_ids = module.network.public_subnets_ids
  instance_type = "t2.micro"
  ssh_sec_group_id = module.network.ssh_security_group_id
  vpc_id = module.network.vpc_id
}

module "web2" {
  source = "./modules/compute"

  sec_group_name = "web2"
  env = terraform.workspace
  subnet_ids = module.network.private_subnet_ids
  instance_type = "t2.micro"
  ssh_sec_group_id = module.network.ssh_security_group_id
  vpc_id = module.network.vpc_id
}

