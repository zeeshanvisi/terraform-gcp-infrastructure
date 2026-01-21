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

# GCS bucket for application logs with versioning and encryption
resource "google_storage_bucket" "terraform_test" {
  name     = var.bucket_name
  location = var.region
  project  = var.project_id

  # Development environment configuration
  storage_class                   = "STANDARD"
  uniform_bucket_level_access     = true
  public_access_prevention        = "enforced"
  force_destroy                   = true  # For dev environment

  # Enable versioning for data protection
  versioning {
    enabled = true
  }

  # Lifecycle management for cost optimization in dev
  lifecycle_rule {
    condition {
      age = 30  # Delete objects older than 30 days in dev
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Soft delete policy for development (7 days retention)
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days
  }

  # Labels for resource management and cost tracking
  labels = {
    environment = "dev"
    purpose     = "application-logs"
    managed-by  = "terraform"
    project     = "visionet-merck-poc"
    cost-center = "development"
  }
}

# IAM binding for application access
resource "google_storage_bucket_iam_binding" "log_writers" {
  bucket = google_storage_bucket.terraform_test.name
  role   = "roles/storage.objectCreator"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}

resource "google_storage_bucket_iam_binding" "log_readers" {
  bucket = google_storage_bucket.terraform_test.name
  role   = "roles/storage.objectViewer"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}