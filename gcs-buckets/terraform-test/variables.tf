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
  description = "Name of the GCS bucket"
  type        = string
  default     = "terraform-test"
  
  validation {
    condition = can(regex("^[a-z0-9][a-z0-9\\-_]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be lowercase alphanumeric with hyphens/underscores only."
  }
}

variable "notification_topic" {
  description = "Pub/Sub topic for bucket notifications (optional)"
  type        = string
  default     = ""
}

variable "labels" {
  description = "Additional labels to apply to the bucket"
  type        = map(string)
  default     = {}
}

variable "lifecycle_age_delete" {
  description = "Age in days after which objects are deleted"
  type        = number
  default     = 30
}

variable "lifecycle_age_nearline" {
  description = "Age in days after which objects are moved to NEARLINE storage"
  type        = number
  default     = 7
}