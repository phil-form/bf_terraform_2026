variable "region" {
  description = "Region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to deploy"
  type        = string
  default     = "t2.micro"
}