variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
  default     = "visionet-merck-poc"
  
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID cannot be empty."
  }
}

variable "region" {
  description = "The GCP region where the bucket will be created"
  type        = string
  default     = "us-east5"
  
  validation {
    condition = contains([
      "us-east5", "us-central1", "us-west1", "us-west2", 
      "us-east1", "us-east4", "europe-west1", "asia-east1"
    ], var.region)
    error_message = "Region must be a valid GCP region."
  }
}

variable "retention_days" {
  description = "Number of days to retain logs before deletion"
  type        = number
  default     = 365
  
  validation {
    condition     = var.retention_days >= 30 && var.retention_days <= 3650
    error_message = "Retention days must be between 30 and 3650 days."
  }
}

variable "enable_logging" {
  description = "Enable access and storage logging for the bucket"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}