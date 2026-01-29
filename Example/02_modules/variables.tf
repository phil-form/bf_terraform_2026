variable "region" {
  type = string
  description = "Region ou déployer les ressources"
  default = "us-east-1"
}

variable "instance_type" {
  description = "Type d'instances à utiliser pour les VMs"
  type = string
  default = "t2.micro"
}
