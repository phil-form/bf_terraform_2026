variable "region" {
  description = "Region to deploy resources in"
  type        = string
  default     = "us-east-1"
}
variable "env" { type = string }
variable "instance_type" {
  description = "Type d'instance VM AWS"
  type        = string
  default     = "t2.micro"
}
