### THIS IS THE INSTANCE TEMPLATE
resource "google_compute_instance_template" "maintemplate" {
  name         = "maintemplate"
  machine_type = "n2-standard-2"
  region       = "us-east4"

  disk {
    boot = true
    source_image = "debian-cloud/debian-12"
  }


  network_interface {
    network = google_compute_network.main.name 
    subnetwork = google_compute_subnetwork.virginia-private.name 

    access_config {
      // Ephemeral Public IP 
    }
  }

  metadata_startup_script = file("./startup.sh")
}

### THIS IS THE HEALTH CHECK FOR PORT 80 ON THE INSTANCE GROUP

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2 # 50 seconds

  http_health_check {
    port         = "80"
  }
}

resource "google_compute_region_autoscaler" "mainautoscaler" {
  name   = "virginia-autoscaler"
  region = "us-east4"
  target = google_compute_region_instance_group_manager.maingroup.id

  autoscaling_policy {
    max_replicas    = 9
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_region_instance_group_manager" "maingroup" {
  name = "maingroup"

  base_instance_name         = "virginiaapp"
  region                     = "us-east4"
  distribution_policy_zones  = ["us-east4-a", "us-east4-b", "us-east4-c"]

  version {
    instance_template = google_compute_instance_template.maintemplate.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 60
  }
}