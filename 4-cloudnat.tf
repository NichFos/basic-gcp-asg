# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "virginia-nat" {
  name   = "virginia-nat"
  router = google_compute_router.virginia-router.name
  region = "us-east4"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.virginia-private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.virginia-nat.self_link]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "virginia-nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region = "us-east4"
}

resource "google_compute_router_nat" "northcarolina-nat" {
  name   = "northcarolina-nat"
  router = google_compute_router.northcarolina-router.name
  region = "us-east1"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.nc-private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.northcarolina-nat.self_link]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "northcarolina-nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region = "us-east1"
}