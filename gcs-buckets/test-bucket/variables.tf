variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "visionet-merck-poc"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-east5"
}

variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
  default     = "visionet-test-bucket-20240121075456"
}

variable "location" {
  description = "GCS bucket location"
  type        = string
  default     = "US"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "development"
}
