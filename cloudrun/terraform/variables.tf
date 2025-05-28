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


variable "service_name" {
  default = "test-bq"
}
variable "image_url" {}