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
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "purpose" {
  description = "Purpose of the bucket"
  type        = string
  default     = "application-logs"
}