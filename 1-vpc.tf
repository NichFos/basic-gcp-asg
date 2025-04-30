# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "main" {
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "virginia-private" {
  name                     = "virginia-private"
  ip_cidr_range            = "10.80.25.0/24"
  region                   = "us-east4"
  network                  = google_compute_network.main.id
  private_ip_google_access = true
}


resource "google_compute_subnetwork" "us-east4-private" {
  name                     = "northcarolina-private"
  ip_cidr_range            = "10.80.35.0/24"
  region                   = "us-east1"
  network                  = google_compute_network.main.id
  private_ip_google_access = true
}