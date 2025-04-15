provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("gcp-key.json")
}

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


resource "google_storage_bucket" "demo_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true
}
