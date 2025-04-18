# Extremely important in order to keep all the .tfstate of terraform and be able to use Pipeline
# to destroy or create
terraform {
  # Configure the backend to use GCS for storing the Terraform state.
  backend "gcs" {
    # Name of the GCS bucket where the state will be stored
    bucket = "consummate-fold-456420-b6_state_bucket_terraform" # This is your GCS bucket name

    # Prefix (optional) for organizing the state files inside the bucket
    # This can be useful if you have multiple environments, e.g., dev, staging, prod
    prefix = "terraform/state" # This specifies the folder structure within the bucket
  }
}

# The rest of your Terraform configuration would go here (resources, modules, etc.)

########################################################################################################################
########################################################################################################################
########################################################################################################################

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("gcp-key.json")
}

resource "google_storage_bucket" "demo_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true
}

#
#
#####################################################    VM    #########################################################

resource "google_compute_instance" "vm_kestra" {
  name         = "kestra-vm"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20250415"
      size  = 30
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("install.sh")

  tags = ["http-server", "https-server"]
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"] # TODO MUST BE CHANGE AS SOON AS POSSIBLE
  target_tags   = ["http-server", "https-server"]
}

output "vm_ip" {
  value = google_compute_instance.vm_kestra.network_interface[0].access_config[0].nat_ip
}

#
#
################################################ POSTGRES DB ###########################################################

resource "google_sql_database_instance" "kestra" {
  deletion_protection = var.enable_deletion_protection #TODO just for dev
  name             = var.db_instance_name
  database_version = "POSTGRES_13"
  region           = var.region
  depends_on = [google_compute_instance.vm_kestra] #this is not strictly necessary! but it is ok to use it
  settings {
    tier = "db-f1-micro"  # change if needed
    ip_configuration {
      ipv4_enabled    = true
      authorized_networks {
        name  = "vm-access"
        value = google_compute_instance.vm_kestra.network_interface[0].access_config[0].nat_ip
      }
    }
  }
}

resource "google_sql_user" "kestra_user" {
  name     = "kestra"
  instance = google_sql_database_instance.kestra.name
  password = var.db_password # or use Terraform secrets
}

resource "google_sql_database" "kestra_db" {
  name     = "kestra"
  instance = google_sql_database_instance.kestra.name
}