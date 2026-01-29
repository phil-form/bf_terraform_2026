terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
resource "aws_vpc" "this" {
  cidr_block = var.cird_block

  tags = merge({ Name = "${var.env}-vpc" }, var.tags)
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.this.id

  count = length(var.public_subnets)
  cidr_block = var.public_subnets[count.index]
  availability_zone = element(var.available_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge({ Name = "${var.env}-public-${count.index}" }, var.tags)
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.this.id

  count = length(var.private_subnets)
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(var.available_zones, count.index)

  tags = merge({ Name = "${var.env}-private-${count.index}" }, var.tags)
}