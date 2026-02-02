variable "cidr_block" { type = string }
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "available_zones" { type = list(string) }
variable "env" { type = string }
variable "tags" {
  type = map(string)
  default = {}
}