terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Minimal GCS bucket for auto-apply testing
resource "google_storage_bucket" "auto_apply_test" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true  # For easy cleanup in dev
  
  # Basic lifecycle to prevent accidental public access
  public_access_prevention = "enforced"
  
  # Dev environment - basic versioning
  versioning {
    enabled = true
  }
  
  labels = {
    environment = "dev"
    purpose     = "auto-apply-test"
    managed-by  = "terraform"
  }
}
