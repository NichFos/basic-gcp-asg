# resource "google_compute_instance" "virginia-apptest" {
#   name         = "virginia-apptest"
#   machine_type = "n2-standard-2"
#   zone         = "us-east4-a"

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-12"
#     }
#   }
  
#   network_interface {
#     network    = google_compute_network.main.name
#     subnetwork = google_compute_subnetwork.virginia-private.name

#     access_config {
#       // Ephemeral public IP
#     }
#   }

  
#   metadata_startup_script = file("./startup.sh")
# }

# resource "google_compute_instance" "netherlands1-apptest" {
#   name         = "netherlands1-apptest"
#   machine_type = "n2-standard-2"
#   zone         = "europe-west4-a"

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-12"
#     }
#   }
  
#   network_interface {
#     network    = google_compute_network.main.name
#     subnetwork = google_compute_subnetwork.netherlands1-private.name 

#     access_config {
#       // Ephemeral public IP
#     }
#   }

  
#   metadata_startup_script = file("./startup.sh")
# }


# resource "google_compute_instance" "saopaulo-apptest" {
#   name         = "saopaulo-apptest"
#   machine_type = "n2-standard-2"
#   zone         = "southamerica-east1-a"

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-12"
#     }
#   }
  
#   network_interface {
#     network    = google_compute_network.main.name
#     subnetwork = google_compute_subnetwork.saopaulo-private.name 

#     access_config {
#       // Ephemeral public IP
#     }
#   }

  
#   metadata_startup_script = file("./startup.sh")
# }


# /*This code is not needed in the current configuration, this will simply be commented out until such time as I need to create VMs for testing purposes, 
# because I am lazy and do not want to retype it again*/