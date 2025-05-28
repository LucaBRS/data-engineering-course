project_id                 = "test-cloud-run-firebase"
region                     = "europe-west8"
zone                       = "europe-west8-b"
enable_deletion_protection = false # Set to true in prod
image_name                 = "test-bq"

image_url                  = "gcr.io/test-cloud-run-firebase/hello-bigquery"
