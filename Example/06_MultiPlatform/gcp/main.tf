module "network" {
  source = "./modules/network"
  network_name = "demo-network"
  subnet_cidrs = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

module "compute" {
  count = length(module.network.subnet_link)
  source = "./modules/compute"
  subnet_self_link = module.network.subnet_link[count.index]
  env = terraform.workspace
  suffix = "${count.index + 1}"
}