variable "env" { type = string }
variable "prefix" { type = string }
variable "cidr_block" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "az" { type = list(string) }
variable "tags" {
  type = map(string)
  default = {}
}
