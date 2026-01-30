resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags      = merge({ Name = "tf-${var.env}-vpc" }, var.tags)
}

resource "aws_security_group" "sg" {
  name       = "tf-${var.env}-compute-sg"
  description = "Security group for compute instances"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "public" {
    count                   = length(var.public_subnets)
    vpc_id                  = aws_vpc.this.id
    cidr_block              = var.public_subnets[count.index]
    map_public_ip_on_launch = true
    tags = merge(
        {
        Name = "tf-${var.env}-public-subnet-${count.index + 1}"
        },
        var.tags,
    )
}

resource "aws_subnet" "private" {
    count      = length(var.private_subnets)
    vpc_id     = aws_vpc.this.id
    cidr_block = var.private_subnets[count.index]
    tags = merge(
        {
        Name = "tf-${var.env}-private-subnet-${count.index + 1}"
        },
        var.tags,
    )
}
