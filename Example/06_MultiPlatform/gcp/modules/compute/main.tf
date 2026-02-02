resource "google_compute_instance" "this" {
  # https://docs.cloud.google.com/compute/docs/general-purpose-machines#e2_machine_types
  machine_type = "e2-micro"
  name         = "${var.env}-web-${var.suffix}"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian11"
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    access_config {}
  }

  tags = ["web", "ssh"]
}