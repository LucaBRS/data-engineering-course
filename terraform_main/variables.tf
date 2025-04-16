variable "project_id" {
  default = "consummate-fold-456420-b6"
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
  default     = "consummate-fold-456420-b6-terra-bucket"
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