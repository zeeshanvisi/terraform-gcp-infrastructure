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
  default     = "prod-backup-storage"
  
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters, lowercase, and contain only letters, numbers, hyphens, periods, and underscores."
  }
}

variable "storage_class" {
  description = "Storage class for the bucket"
  type        = string
  default     = "STANDARD"
  
  validation {
    condition = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be one of: STANDARD, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "lifecycle_age_days" {
  description = "Number of days after which objects will be deleted"
  type        = number
  default     = 90
  
  validation {
    condition     = var.lifecycle_age_days > 0 && var.lifecycle_age_days <= 3650
    error_message = "Lifecycle age must be between 1 and 3650 days."
  }
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}