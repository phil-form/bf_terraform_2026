output "instance_id" {
  value = aws_instance.this[*].id
}

output "instance_netinfo" {
  value = {
    private_dns = aws_instance.this[*].public_dns
    private_ip = aws_instance.this[*].private_ip
    public_dns = aws_instance.this[*].public_dns
    public_id = aws_instance.this[*].public_ip
  }
}