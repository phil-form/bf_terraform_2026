output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "ssh_security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sg.id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnets_ids" {
  description = "The private subnets CIDR blocks"
  value       = aws_subnet.public[*].id
}
