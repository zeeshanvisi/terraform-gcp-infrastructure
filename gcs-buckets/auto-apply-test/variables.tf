variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "visionet-merck-poc"
}

variable "region" {
  description = "GCP region for the bucket"
  type        = string
  default     = "us-west2"
}

variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
  default     = "auto-apply-test-bucket-001"
  
  validation {
    condition = can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be 3-63 characters, start and end with alphanumeric, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "test"
}