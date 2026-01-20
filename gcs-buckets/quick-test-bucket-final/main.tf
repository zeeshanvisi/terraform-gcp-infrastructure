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

# Get current client configuration
data "google_client_config" "default" {}

# Quick test GCS bucket
resource "google_storage_bucket" "quick_test_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true # Safe for test bucket

  # Storage class optimized for test workloads
  storage_class = "STANDARD"
  
  # Security best practices - even for test
  uniform_bucket_level_access = true
  public_access_prevention   = "enforced"
  
  # Lifecycle management for test data
  lifecycle_rule {
    condition {
      age = 30 # Auto-delete test objects after 30 days
    }
    action {
      type = "Delete"
    }
  }

  # Abort incomplete uploads after 1 day
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Soft delete policy (7 days retention)
  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  # Labels for cost tracking and management
  labels = {
    environment = "test"
    purpose     = "quick-test"
    region      = replace(var.region, "-", "_")
    managed_by  = "terraform"
  }
}