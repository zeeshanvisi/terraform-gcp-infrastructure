terraform {
  required_version ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.16"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Simple GCS bucket with versioning enabled
resource "google_storage_bucket" "test_bucket" {
  name     = var.bucket_name
  location = var.location
  project  = var.project_id

  # Force destroy for dev/test purposes - allows deletion even with objects
  force_destroy = true

  # Storage class for standard access
  storage_class = "STANDARD"

  # Enable versioning
  versioning {
    enabled = true
  }

  # Security: Uniform bucket-level access
  uniform_bucket_level_access = true

  # Security: Prevent public access
  public_access_prevention = "enforced"

  # Labels for cost tracking and organization
  labels = {
    environment = var.environment
    purpose     = "test-bucket"
    managed_by  = "terraform"
  }
}
