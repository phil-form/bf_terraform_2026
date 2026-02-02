variable "env" { type = string }
variable "prefix" { type = string }
variable "db_name" { type = string }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "instance_class" { type = string }
variable "sg_ssh_id" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type = string
  sensitive = true
}