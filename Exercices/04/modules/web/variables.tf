variable "env" { type = string}
variable "prefix" { type = string }
variable "instance_type" { type = string }
variable "subnets" { type = list(string) }
variable "ssh_sg_id" { type = string }
variable "vpc_id" { type = string }
