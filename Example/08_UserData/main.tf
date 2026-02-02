provider "aws" {
  region = "us-east-1"

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


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"] # Amazon
}

data "aws_availability_zones" "az" {}

module "aws_network" {
  source = "./modules/network"

  cidr_block = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.10.0/24"]
  available_zones = data.aws_availability_zones.az.names
  env = "dev"
}

data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_security_group" "web_sec" {
  name = "dev-sec-grp"
  vpc_id = module.aws_network.vpc_id
  description = "Allow SSH and HTTP"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "data" {
  count = length(module.aws_network.public_subnit_ids)
  size = 10
  availability_zone = data.aws_availability_zones.az.names[0]
  tags = {
    Name = "data-volume-${count.index + 1}"
  }
}

resource "aws_volume_attachment" "attach" {
  count = length(module.aws_network.public_subnit_ids)
  device_name = "/dev/sdh"

  instance_id = aws_instance.web_app[count.index].id
  volume_id   = aws_ebs_volume.data[count.index].id
}

resource "aws_instance" "web_app" {
  count = length(module.aws_network.public_subnit_ids)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = element(module.aws_network.public_subnit_ids, count.index)
  vpc_security_group_ids = [aws_security_group.web_sec.id]

  tags = {
    Name = "learn-terraform"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip}, ${self.public_dns} >> instances_info.txt"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Welcome to Terraform Demo Application</h1>" | sudo tee /var/www/html/index.html
  EOF
}

resource "aws_instance" "web_app1" {
  count = length(module.aws_network.public_subnit_ids)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = element(module.aws_network.public_subnit_ids, count.index)
  vpc_security_group_ids = [aws_security_group.web_sec.id]

  tags = {
    Name = "learn-terraform"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip}, ${self.public_dns} >> instances_info.txt"
  }

  user_data = <<-EOF
                #cloud-config
                package_update: true
                packages:
                    - apache2
                runcmd:
                    - systemctl start apache2
                    - systemctl enable apache2
                    - echo "<h1>Welcome to Terraform Demo Application</h1>" | tee /var/www/html/index.html
              EOF
}

resource "aws_instance" "web_app2" {
  count = length(module.aws_network.public_subnit_ids)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = element(module.aws_network.public_subnit_ids, count.index)
  vpc_security_group_ids = [aws_security_group.web_sec.id]

  tags = {
    Name = "learn-terraform"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip}, ${self.public_dns} >> instances_info.txt"
  }

  user_data = file("./deploy/install_apache.sh")
}

resource "aws_instance" "web_app3" {
  count = length(module.aws_network.public_subnit_ids)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = element(module.aws_network.public_subnit_ids, count.index)
  vpc_security_group_ids = [aws_security_group.web_sec.id]

  tags = {
    Name = "learn-terraform"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip}, ${self.public_dns} >> instances_info.txt"
  }

  user_data = templatefile("./deploy/install_apache.yml", {})
}

resource "aws_instance" "web_app4" {
  count = length(module.aws_network.public_subnit_ids)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = element(module.aws_network.public_subnit_ids, count.index)
  vpc_security_group_ids = [aws_security_group.web_sec.id]

  tags = {
    Name = "learn-terraform"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip}, ${self.public_dns} >> instances_info.txt"
  }

  user_data = templatefile("./deploy/docker-init-docker-compose.yml", {
    compose_file_content = file("./deploy/docker-compose.yml")
  })
}
