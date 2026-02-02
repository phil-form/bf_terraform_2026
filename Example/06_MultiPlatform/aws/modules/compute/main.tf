resource "aws_security_group" "sg" {
  name       = "tf-${var.env}-compute-sg-${var.sec_group_name}"
  description = "Security group for compute instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "awslinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "web" {
  count = length(var.subnet_ids)
  ami = data.aws_ami.awslinux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id, var.ssh_sec_group_id]
  tags = merge(
    {
      Name = "tf-${var.env}-compute-instance-${count.index + 1}"
    },
    var.tags,
  )
}