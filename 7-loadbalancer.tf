# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_health_check
# Resource: Regional Health Check
resource "google_compute_region_health_check" "virginia-lb-healthcheck" {
  name                = "lb-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    request_path = "/index.html"
    port         = 80
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service
# Resource: Regional Backend Service
resource "google_compute_region_backend_service" "virginia-lb-backend" {
  name                  = "lb-backend-service"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_region_health_check.virginia-lb-healthcheck.self_link]
  port_name             = "webserver"
  backend {
    group           = google_compute_region_instance_group_manager.maingroup.instance_group
    capacity_scaler = 1.0
    balancing_mode  = "UTILIZATION"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
# Resource: Reserve Regional Static IP Address
resource "google_compute_address" "virginia-lb" {
  name   = "virginia-lb-static-ip"
  region = "us-east4"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule
# Resource: Regional Forwarding Rule
resource "google_compute_forwarding_rule" "lb" {
  name                  = "lb-forwarding-rule"
  target                = google_compute_region_target_http_proxy.lb.self_link
  port_range            = "80"
  ip_protocol           = "TCP"
  ip_address            = google_compute_address.virginia-lb.address
  load_balancing_scheme = "EXTERNAL_MANAGED" # Current Gen LB (not classic)
  network               = google_compute_network.main.id

  # During the destroy process, we need to ensure LB is deleted first, before proxy-only subnet
  depends_on = [google_compute_subnetwork.regional_proxy_subnet]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map
# Resource: Regional URL Map
resource "google_compute_region_url_map" "virginia-lb-map" {
  name            = "lb-url-map"
  default_service = google_compute_region_backend_service.virginia-lb-backend.self_link
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_http_proxy
# Resource: Regional HTTP Proxy
resource "google_compute_region_target_http_proxy" "lb" {
  name    = "lb-http-proxy"
  url_map = google_compute_region_url_map.virginia-lb-map.self_link
}