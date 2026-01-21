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

variable "project_number" {
  description = "GCP project number for service account references"
  type        = string
  default     = "123456789"  # Update with actual project number if known
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "team_email" {
  description = "Development team email group for IAM access"
  type        = string
  default     = "developers@visionet.com"
}