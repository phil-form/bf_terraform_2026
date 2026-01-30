data "aws_ami" "linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-ebs"]
  }

  owners = ["137112412989"]
}

resource "aws_instance" "web" {
  ami = data.aws_ami.linux.id
  instance_type = var.instance_type
  count = 2
}