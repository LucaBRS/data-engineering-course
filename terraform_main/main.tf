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
