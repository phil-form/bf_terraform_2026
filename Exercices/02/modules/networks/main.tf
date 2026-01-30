terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = merge({ Name = "${var.env}-vpc" }, var.tags)
}

resource "aws_security_group" "sg_ssh" {
  name = "${var.env}-sec-grp-ssh"
  description = "Security Group ssh"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 22
    to_port = 22
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

resource "aws_security_group" "sg_http" {
  name = "${var.env}-sec-grp-http"
  description = "Security Group ssh"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
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

resource "aws_security_group" "sg_psql" {
  name = "${var.env}-sec-grp-psql"
  description = "Security Group psql"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.cidr_block]
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.this.id

  count = length(var.public_subnets)
  availability_zone = element(var.available_zones, count.index)
  map_public_ip_on_launch = true
  cidr_block = var.public_subnets[count.index]

  tags = merge({ Name = "${var.env}-public-${count.index}" })
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.this.id

  count = length(var.private_subnets)
  availability_zone = element(var.available_zones, count.index)
  cidr_block = var.private_subnets[count.index]

  tags = merge({ Name = "${var.env}-private-${count.index}" })
}