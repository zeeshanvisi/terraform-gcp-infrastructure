variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "visionet-merck-poc"
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-east5"
}

variable "location" {
  description = "GCS bucket location (multi-region for HA)"
  type        = string
  default     = "US"  # Multi-region for high availability
}

variable "bucket_name" {
  description = "Base name for the GCS bucket (suffix will be added for uniqueness)"
  type        = string
  default     = "company-backups"
}

variable "lifecycle_age_days" {
  description = "Number of days after which objects are deleted"
  type        = number
  default     = 365
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}