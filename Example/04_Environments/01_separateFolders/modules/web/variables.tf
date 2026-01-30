variable "instance_type" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "env" { type = string }
variable "ssh_sec_group_id" { type = string }
variable "sec_group_name" { type = string }
variable "tags" {
  type = map(string)
  default = {}
}