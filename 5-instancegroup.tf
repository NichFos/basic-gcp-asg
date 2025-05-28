### THESE ARE THE INSTANCE TEMPLATES
resource "google_compute_instance_template" "virginia-app01template-terraform" {
  name         = "virginia-app01template-terraform"
  description  = "Resource template for virginia-app01"
  machine_type = "n2-standard-2"
  region       = "us-east4"

  disk {
    boot = true
    source_image = "debian-cloud/debian-12"
  }


  network_interface { 
    network    = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.virginia-private.id
  }

  metadata_startup_script = file("./startup.sh")
}


resource "google_compute_instance_template" "netherlands1-app01template-terraform" {
  name         = "netherlands1-app01template-terraform"
  description  = "Resource template for netherlands1-app01"
  machine_type = "n2-standard-2"
  region       = "europe-west1"

  disk {
    boot = true
    source_image = "debian-cloud/debian-12"
  }


  network_interface { 
    network    = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.netherlands1-private.id

    access_config {
      // Ephemeral Public IP 
    }
  }

  metadata_startup_script = file("./startup.sh")
}

resource "google_compute_instance_template" "nc-private-app01template-terraform" {
  name         = "nc-private-app01template-terraform"
  description  = "Resource template for nc-private-app01"
  machine_type = "n2-standard-2"
  region       = "us-east1"

  disk {
    boot = true
    source_image = "debian-cloud/debian-12"
  }


  network_interface { 
    network    = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.northcarolina-private.id 

    access_config {
      // Ephemeral Public IP 
    }
  }

  metadata_startup_script = file("./startup.sh")
}



resource "google_compute_instance_template" "saopaulo1-app01template-terraform" {
  name         = "saopaulo1-app01template-terraform"
  description  = "Resource template for saopaulo1-app01"
  machine_type = "n2-standard-2"
  region       = "southamerica-east1"

  disk {
    boot = true
    source_image = "debian-cloud/debian-12"
  }


  network_interface { 
    network    = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.saopaulo-private.id

    access_config {
      // Ephemeral Public IP 
    }
  }

  metadata_startup_script = file("./startup.sh")
}

## THIS IS THE HEALTH CHECK FOR PORT 80 ON THE INSTANCE GROUP

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2 # 50 seconds

  http_health_check {
    port         = "80"
    request_path = "/index.html"
  }
}

resource "google_compute_region_autoscaler" "virginia-autoscaler" {
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

data "google_compute_zones" "available" {
  status = "UP"
  #region = "" (optional if provider default is set)
}


resource "google_compute_region_instance_group_manager" "maingroup" {
  name                       = "maingroup"
  base_instance_name         = "virginia-app01"
  region                     = "us-east4"
  distribution_policy_zones  = data.google_compute_zones.available.names

  version {
    instance_template = google_compute_instance_template.virginia-app01template-terraform.self_link
  }

named_port {
  name = "webserver"
  port = 80
}
  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 60
  }
}