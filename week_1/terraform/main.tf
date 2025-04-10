terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  # THIS IS NOT THE BEST WAY !!!!!
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}


# this important to terraform to understand what resources is creating
# the second quotes is important for us
resource "google_storage_bucket" "demo-bucket" {
  location = "EU"
  #the name here must be unique!
  name          = var.gcs_bucket_name
  force_destroy = true

  lifecycle_rule {
    action {
      type = "AbortIncompleteMultipartUpload"
    }
    condition {
      age = 1
    }
  }

}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id                 = var.bq_dataset_name
  delete_contents_on_destroy = true
  location                   = var.location
}