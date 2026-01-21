variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "visionet-merck-poc"
}

variable "region" {
  description = "GCP region for bucket location"
  type        = string
  default     = "us-east5"
}

variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
  default     = "terraform-test"
  
  validation {
    condition     = length(var.bucket_name) > 3 && length(var.bucket_name) < 64
    error_message = "Bucket name must be between 3 and 63 characters."
  }
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}