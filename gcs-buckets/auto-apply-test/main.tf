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

# Test GCS bucket with appropriate test environment settings
resource "google_storage_bucket" "auto_apply_test_bucket" {
  name     = var.bucket_name
  location = var.region

  # Test environment settings
  force_destroy               = true  # Allow easy cleanup in test env
  uniform_bucket_level_access = true  # Modern security practice
  
  # Basic lifecycle rule for cost optimization in test env
  lifecycle_rule {
    condition {
      age = 30  # Delete objects older than 30 days
    }
    action {
      type = "Delete"
    }
  }

  # Abort incomplete multipart uploads after 1 day
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Versioning disabled for test environment (cost optimization)
  versioning {
    enabled = false
  }

  # Labels for tracking and cost management
  labels = {
    environment   = "test"
    purpose      = "auto-apply-testing"
    managed_by   = "terraform"
    team         = "infrastructure"
    auto_cleanup = "enabled"
  }
}