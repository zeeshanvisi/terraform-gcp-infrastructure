variable "project_id" {
  description = "GCP project ID where resources will be created"
  type        = string
  default     = "visionet-merck-poc"
}

variable "region" {
  description = "GCP region for bucket location"
  type        = string
  default     = "us-central1"
}

variable "bucket_name_prefix" {
  description = "Prefix for the bucket name (timestamp will be appended)"
  type        = string
  default     = "test-prod-bucket"
}

variable "retention_days" {
  description = "Number of days to retain objects in the bucket"
  type        = number
  default     = 90
  
  validation {
    condition     = var.retention_days > 0
    error_message = "Retention days must be greater than 0."
  }
}

variable "environment" {
  description = "Environment name (e.g., prod, staging, dev)"
  type        = string
  default     = "production"
}

variable "cost_center" {
  description = "Cost center for billing and cost allocation"
  type        = string
  default     = "infrastructure"
}