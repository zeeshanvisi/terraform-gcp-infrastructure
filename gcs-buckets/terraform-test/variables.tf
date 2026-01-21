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
  description = "Base name of the GCS bucket (random suffix will be added)"
  type        = string
  default     = "visionet-test-logs"
  
  validation {
    condition     = length(var.bucket_name) > 3 && length(var.bucket_name) < 50
    error_message = "Bucket base name must be between 3 and 49 characters (allows room for random suffix)."
  }
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}