# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket      = "terraformstateoneagain"
    prefix      = "terraform/state"
    credentials = "class65gcpproject-852c98beb4bd.json"
}

required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}


# resource "google_compute_disk" "grafana_disk" {
#   name  = "grafana-disk"
#   type  = "pd-standard"
#   zone  = "us-central1-a"
#   size  = "10"
# }

### Grafana disk was commented out because this may be used for Kubernetes classes in the future. 