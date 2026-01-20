terraform {
  required_version = ">= 1.0"
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

# Simple test bucket
resource "google_storage_bucket" "test_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true  # For test environment - allows bucket deletion with objects

  # Basic test configuration
  storage_class = "STANDARD"
  
  # Security defaults
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  # Labels for tracking
  labels = {
    environment = "test"
    purpose     = "testing"
    managed_by  = "terraform"
  }
}