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

variable "bucket_name" {
  description = "Base name for the analytics bucket (suffix will be added for uniqueness)"
  type        = string
  default     = "prod-analytics-data"
}

variable "environment" {
  description = "Environment designation"
  type        = string
  default     = "production"
}

variable "team" {
  description = "Team responsible for this bucket"
  type        = string
  default     = "analytics"
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
  default     = "analytics-team"
}

variable "lifecycle_delete_age_days" {
  description = "Number of days after which objects are deleted"
  type        = number
  default     = 90
}

variable "noncurrent_version_delete_days" {
  description = "Number of days after which non-current versions are deleted"
  type        = number
  default     = 30
}

variable "soft_delete_retention_seconds" {
  description = "Soft delete retention period in seconds (7 days = 604800)"
  type        = number
  default     = 604800
}