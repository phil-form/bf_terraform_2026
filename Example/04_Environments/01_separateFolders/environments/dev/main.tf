provider "aws" {
  region = var.region

  access_key = "anaccesskey"
  secret_key = "asecretkey"
  s3_use_path_style = true
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_requesting_account_id = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}

module "network" {
  source = "./modules/network"

  env    = terraform.workspace
  cidr_block = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24"]
}

module "web" {
  source = "./modules/web"

  sec_group_name = "web"
  env = terraform.workspace
  subnet_ids = module.network.public_subnets_ids
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t2.micro"
  ssh_sec_group_id = module.network.ssh_security_group_id
  vpc_id = module.network.vpc_id
}

module "web2" {
  source = "./modules/web"

  sec_group_name = "web2"
  env = terraform.workspace
  subnet_ids = module.network.private_subnet_ids
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t2.micro"
  ssh_sec_group_id = module.network.ssh_security_group_id
  vpc_id = module.network.vpc_id
}

