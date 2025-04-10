variable "project" {
  default = "consummate-fold-456420-b6"
}

variable "region" {
  default = "europe-west8"
}

variable "location" {
  description = "prog location"
  default     = "EU"
}

variable "gcs_bucket_name" {
  description = "my storage bucket name "
  default     = "consummate-fold-456420-b6-terra-bucket"
}

variable "bq_dataset_name" {
  description = "my big query dataset name"
  default     = "demo_datase"
}

variable "gcs_storage_class" {
  description = "bucket storage class"
  default     = "STANDARD"
}