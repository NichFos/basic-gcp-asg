# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "northcarolina-router" {
  name    = "northcarolina-router"
  region  = "us-east1"
  network = google_compute_network.main.id
}

resource "google_compute_router" "saopaulo-router" {
  name    = "saopaulo-router"
  region  = "southamerica-east1"
  network = google_compute_network.main.id
}

resource "google_compute_router" "netherlands-router" {
  name    = "netherlands-router"
  region  = "europe-west1"
  network = google_compute_network.main.id
}

resource "google_compute_router" "virginia-router" {
  name    = "virginia-router"
  region  = "us-east4"
  network = google_compute_network.main.id
}