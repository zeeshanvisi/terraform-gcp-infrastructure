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

# Development GCS bucket for application logs with versioning and encryption
resource "google_storage_bucket" "terraform_test" {
  name          = var.bucket_name
  location      = var.region
  project       = var.project_id
  force_destroy = true  # For dev environment - allows easy cleanup

  # Versioning configuration
  versioning {
    enabled = true
  }

  # Storage class optimized for logs (frequent access initially, then archive)
  storage_class = "STANDARD"

  # Lifecycle management for cost optimization in dev
  lifecycle_rule {
    condition {
      age = 30  # Move to nearline after 30 days
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 90  # Move to coldline after 90 days
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365  # Delete after 1 year (dev environment)
    }
    action {
      type = "Delete"
    }
  }

  # Clean up incomplete multipart uploads after 7 days
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Uniform bucket-level access for better security
  uniform_bucket_level_access = true

  # Public access prevention
  public_access_prevention = "enforced"

  # Soft delete policy (7 days retention)
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days
  }

  # Labels for cost tracking and organization
  labels = {
    environment = "dev"
    purpose     = "application-logs"
    managed-by  = "terraform"
    owner       = "development-team"
  }
}

# IAM binding for development team access
resource "google_storage_bucket_iam_binding" "bucket_admin" {
  bucket = google_storage_bucket.terraform_test.name
  role   = "roles/storage.admin"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}

# IAM binding for object creator (applications can write logs)
resource "google_storage_bucket_iam_binding" "object_creator" {
  bucket = google_storage_bucket.terraform_test.name
  role   = "roles/storage.objectCreator"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}