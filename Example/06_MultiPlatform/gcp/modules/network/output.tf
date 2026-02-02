output "subnet_link" {
  description = "Link to the created subnets"
  value = google_compute_subnetwork.subnet[*].self_link
}