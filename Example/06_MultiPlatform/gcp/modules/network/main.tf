resource "google_compute_network" "this" {
  name = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  count = length(var.subnet_cidrs)
  name    = "${var.network_name}-subnet"
  network = google_compute_network.this.id
  ip_cidr_range = var.subnet_cidrs[count.index]
}

resource "google_compute_firewall" "fw" {
  name    = "${var.network_name}-firewall"
  network = google_compute_network.this.id

  allow {
    protocol = "tcp"
    ports = [
      "22",
      "80",
      "443",
    ]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web", "ssh"]
}