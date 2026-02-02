resource "aws_instance" "this" {
  count = length(var.subnets)

  ami = data.aws_ami.linux.id
  instance_type = var.instance_type
  subnet_id = var.subnets[count.index]
  vpc_security_group_ids = [aws_security_group.sg_https.id, var.ssh_sg_id]

  tags = {
    Name = "web instance"
  }
}

data "aws_ami" "linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"]
}

resource "aws_security_group" "sg_https" {
  name = "${var.prefix}-${var.env}-sec-grp-https"
  description = "Security Group ssh"
  vpc_id = var.vpc_id

  ingress {
  from_port = 443
  to_port = 443
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