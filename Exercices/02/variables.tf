variable "region" {
  description = "Region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "Type d'instance VM AWS"
  type        = string
  default     = "t2.micro"
}