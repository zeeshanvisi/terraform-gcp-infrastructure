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

# GCS Bucket for test verification
resource "google_storage_bucket" "test_verification_bucket" {
  name     = var.bucket_name
  location = var.region
  project  = var.project_id

  # Enable uniform bucket-level access for better security
  uniform_bucket_level_access = true

  # Versioning for test data recovery
  versioning {
    enabled = true
  }

  # Public access prevention
  public_access_prevention = "enforced"

  # Lifecycle management for cost optimization
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  # Labels for cost tracking and organization
  labels = {
    environment = "test"
    purpose     = "verification"
    managed_by  = "terraform"
    team        = "infrastructure"
  }
}

# IAM binding to allow the service account to access the bucket
resource "google_storage_bucket_iam_member" "bucket_admin" {
  bucket = google_storage_bucket.test_verification_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${var.project_id}@appspot.gserviceaccount.com"
}
