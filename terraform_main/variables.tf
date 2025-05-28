variable "project_id" {
  default = "test-cloud-run-firebase"
}

variable "region" {
  default = "europe-west8"
}

variable "zone" {}

variable "location" {
  description = "prog location"
  default     = "EU"
}

variable "bucket_name" {
  description = "my storage bucket name "
  default     = "test-cloud-run-firebase-terra-bucket"
}

variable "db_instance_name" {
  default = "kestra-postgres"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "" # safe fallback
}

variable "enable_deletion_protection" {}

variable "taxy_bucket_name" {}

variable "taxy_bq_name" {}