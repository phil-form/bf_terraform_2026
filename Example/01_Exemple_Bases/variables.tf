variable "instance_type" {
  description = "Le type d'instance (machine virtuelle) aws"
  # Trouver le type d'instance : https://instances.vantage.sh/?id=5f967fd5ad477974c6267adedd6fd92ee404dded
  default = "t2.micro"
  type = string
}
