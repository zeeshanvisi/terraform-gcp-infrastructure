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

# Development GCS bucket with versioning and lifecycle management
resource "google_storage_bucket" "zee_test_bucket" {
  name     = "${var.project_id}-${var.environment}-${var.bucket_name}"
  location = var.region

  # Force destroy for dev environment (allows Terraform to delete non-empty buckets)
  force_destroy = var.environment == "dev" ? true : false

  # Versioning configuration
  versioning {
    enabled = var.versioning_enabled
  }

  # Lifecycle management for cost optimization
  lifecycle_rule {
    condition {
      age = var.lifecycle_delete_age
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = var.lifecycle_nearline_age
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  # Public access prevention (recommended for security)
  public_access_prevention = "enforced"

  # Uniform bucket-level access
  uniform_bucket_level_access = true

  # Labels for resource management and cost tracking
  labels = {
    environment = var.environment
    project     = var.bucket_name
    managed_by  = "terraform"
    purpose     = "development"
  }
}

# IAM binding for bucket access (development team access)
resource "google_storage_bucket_iam_member" "bucket_admin" {
  bucket = google_storage_bucket.zee_test_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${var.project_id}@appspot.gserviceaccount.com"
}

# Optional: Sample object for testing
resource "google_storage_bucket_object" "readme" {
  count  = var.create_sample_object ? 1 : 0
  name   = "README.txt"
  bucket = google_storage_bucket.zee_test_bucket.name
  content = "This is a development GCS bucket created via Terraform.\n\nBucket: ${google_storage_bucket.zee_test_bucket.name}\nCreated: ${timestamp()}\n\nFeatures enabled:\n- Versioning: ${var.versioning_enabled}\n- Lifecycle management: Yes\n- Public access prevention: Enforced\n"
}