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

variable "instance_class" {
  description = "Type d'instance db"
  type = string
  default = "db.t3.micro"
}

variable "db_username" {
  type = string
  default = "test"
}
variable "db_password" {
  type = string
  default = "Test1234=!"
}