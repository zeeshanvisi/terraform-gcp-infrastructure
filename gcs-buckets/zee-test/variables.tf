variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "visionet-merck-poc"
}

variable "region" {
  description = "GCP region for the bucket"
  type        = string
  default     = "us-east5"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Base name for the GCS bucket"
  type        = string
  default     = "zee-test"
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "lifecycle_delete_age" {
  description = "Age in days after which objects are deleted"
  type        = number
  default     = 90
}

variable "lifecycle_nearline_age" {
  description = "Age in days after which objects move to Nearline storage"
  type        = number
  default     = 30
}

variable "create_sample_object" {
  description = "Create a sample README object for testing"
  type        = bool
  default     = true
}

# Validation rules
variable "allowed_environments" {
  description = "List of allowed environment values"
  type        = list(string)
  default     = ["dev", "staging", "prod"]
  
  validation {
    condition     = contains(var.allowed_environments, var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}