variable "project_id" {
  description = "GCP project ID where the bucket will be created"
  type        = string
  default     = "visionet-merck-poc"
}

variable "region" {
  description = "Default GCP region for provider configuration"
  type        = string
  default     = "us-east5"
}

variable "bucket_name" {
  description = "Name of the GCS bucket for application logs"
  type        = string
  default     = "terraform-test"
}

variable "location" {
  description = "GCS bucket location - using dual-region for dev cost optimization"
  type        = string
  default     = "US" # Multi-region for better availability
}

variable "organization_domain" {
  description = "Organization domain for IAM group assignments"
  type        = string
  default     = "example.com" # Update with actual domain
}