resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  # Ici j'ajoute le tag Name avec la valeur de la variable env à la variable tags
  # et j'assigne le combiné de celles-ci dans tags
  tags = merge({ Name = "${var.env}-vpc" }, var.tags)
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = element(var.available_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge({ Name = "${var.env}-public-${count.index}" }, var.tags)
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(var.available_zones, count.index)

  tags = merge({ Name = "${var.env}-private-${count.index}" }, var.tags)
}