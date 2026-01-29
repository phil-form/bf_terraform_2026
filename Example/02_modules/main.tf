data "aws_ami" "linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"]
}

data "aws_availability_zones" "az" {}


module "aws_network" {
  source = "./modules/network"
  providers = { aws = aws }

  cird_block = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.3.0/24"]
  available_zones = data.aws_availability_zones.az.names

  env = "dev"
}

resource "aws_instance" "web_app" {
  count = length(module.aws_network.public_subnet_ids)
  ami = data.aws_ami.linux.id
  instance_type = var.instance_type
  subnet_id = element(module.aws_network.public_subnet_ids, count.index)
  vpc_security_group_ids = [module.aws_network.ssh_sg_id, module.aws_network.http_sg_id]

  tags = {
    Name = "example web app"
  }
}

resource "aws_instance" "private_app" {
  count = length(module.aws_network.private_subnet_ids)
  ami = data.aws_ami.linux.id
  instance_type = var.instance_type
  subnet_id = element(module.aws_network.private_subnet_ids, count.index)
  vpc_security_group_ids = [module.aws_network.ssh_sg_id, module.aws_network.http_sg_id]

  tags = {
    Name = "example web app"
  }
}