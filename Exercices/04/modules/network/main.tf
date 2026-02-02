resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge({ Name = "${var.prefix}-${var.env}-vpc" }, var.tags)
}

# Ajout d'une internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge({ Name = "${var.prefix}-${var.env}-igw" }, var.tags)
}

# Ajoute internet au sous-réseau public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.nat.id

  # Ici j'oblige d'avoir au moins un reseau public dans la configuration
  lifecycle {
    precondition {
      condition = length(var.public_subnets) > 0
      error_message = "You must have a public network to enable NAT gateway to a private network !"
    }
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "sg_ssh" {
  name = "${var.prefix}-${var.env}-sec-grp-ssh"
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

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.this.id

  count = length(var.public_subnets)
  availability_zone = element(var.az, count.index)
  map_public_ip_on_launch = true
  cidr_block = var.public_subnets[count.index]

  tags = merge({ Name = "${var.prefix}-${var.env}-public-${count.index}" })
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.this.id

  count = length(var.private_subnets)
  availability_zone = element(var.az, count.index)
  cidr_block = var.private_subnets[count.index]

  tags = merge({ Name = "${var.prefix}-${var.env}-private-${count.index}" })
}