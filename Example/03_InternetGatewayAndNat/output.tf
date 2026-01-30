output "web_instance" {
  value = {
    id = aws_instance.web[*].id
    public_ip = aws_instance.web[*].public_ip
    private_ip = aws_instance.web[*].private_ip
  }
}