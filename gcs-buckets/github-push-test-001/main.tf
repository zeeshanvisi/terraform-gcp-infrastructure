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

# Test GCS bucket for GitHub push testing
resource "google_storage_bucket" "test_bucket" {
  name     = var.bucket_name
  location = var.region

  # Test bucket configuration - minimal settings
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  # Lifecycle management for test data
  lifecycle_rule {
    condition {
      age = 7  # Delete after 7 days for cost savings
    }
    action {
      type = "Delete"
    }
  }

  # Labels for identification and cost tracking
  labels = {
    environment = "test"
    purpose     = "github-push-testing"
    managed-by  = "terraform"
  }

  # Soft delete for accidental deletion protection
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days
  }
}
