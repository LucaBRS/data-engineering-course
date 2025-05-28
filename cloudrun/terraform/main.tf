provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloud_run_service" "bq_service" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image_url
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "public_access" {
  location        = var.region
  service         = google_cloud_run_service.bq_service.name
  role            = "roles/run.invoker"
  member          = "allUsers"
}
