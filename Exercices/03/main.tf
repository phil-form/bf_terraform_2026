data "aws_ami" "linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"]
}

data "aws_availability_zones" "az" {

}

locals {
  workspace_vars = tomap(
    try(jsondecode(file("${terraform.workspace}.tfvars.json")))
  )

  instance_type = lookup(local.workspace_vars, "instance_type", "t2.micro")
  region = lookup(local.workspace_vars, "region", "us-east-1")
}

module "network" {
  source = "./modules/networks"
  providers = { aws = aws }

  cidr_block = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  available_zones = data.aws_availability_zones.az.names

  env = terraform.workspace
}

resource "aws_instance" "web" {
  count = length(module.network.public_subnet_ids)
  ami = data.aws_ami.linux.id
  instance_type = local.instance_type
  subnet_id = module.network.public_subnet_ids[count.index]
  vpc_security_group_ids = [module.network.http_sg_id, module.network.ssh_sg_id]

  tags = {
    Name = "web instance"
  }
}

resource "aws_instance" "db" {
  count = length(module.network.private_subnet_ids)
  ami = data.aws_ami.linux.id
  instance_type = local.instance_type
  subnet_id = module.network.private_subnet_ids[count.index]
  vpc_security_group_ids = [module.network.db_sg_id, module.network.ssh_sg_id]

  tags = {
    Name = "db instance"
  }
}