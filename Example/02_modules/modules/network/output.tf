output "vpc_id" {
  description = "Id du vpc"
  value = aws_vpc.this.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}