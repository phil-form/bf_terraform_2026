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

output "ssh_sg_id" {
  description = "Id du group de securité ssh"
  value = aws_security_group.sg_ssh.id
}