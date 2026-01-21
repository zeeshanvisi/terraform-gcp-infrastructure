variable "project_id" {
  description = "GCP project ID where the bucket will be created"
  type        = string
  default     = "visionet-merck-poc"
}

variable "region" {
  description = "GCP region for the bucket location"
  type        = string
  default     = "us-east5"
}

variable "bucket_name" {
  description = "Name of the GCS bucket for application logs"
  type        = string
  default     = "terraform-test"
  
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters, lowercase letters, numbers, hyphens, and periods only."
  }
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}