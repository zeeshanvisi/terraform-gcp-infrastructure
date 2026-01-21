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
  description = "GCS bucket location (region or multi-region)"
  type        = string
  default     = "US"  # Multi-region for high availability of production logs
}

variable "bucket_name" {
  description = "Base name for the GCS bucket (suffix will be added for uniqueness)"
  type        = string
  default     = "zee-terra-test"
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
  default     = "production"
}

variable "team" {
  description = "Team responsible for this bucket"
  type        = string
  default     = "platform"
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
  default     = "engineering"
}