terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
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

  # Dev environment - allow force destroy for cleanup
  force_destroy = true

  # Storage class optimized for log data access patterns
  storage_class = "STANDARD"

  # Versioning enabled as requested
  versioning {
    enabled = true
  }

  # Lifecycle management for cost optimization
  lifecycle_rule {
    condition {
      age = 30 # Move logs older than 30 days to Nearline
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 90 # Move logs older than 90 days to Coldline
    }
    action {
      type          = "SetStorageClass" 
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365 # Delete logs older than 1 year
    }
    action {
      type = "Delete"
    }
  }

  # Clean up incomplete multipart uploads after 1 day
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Uniform bucket-level access for simplified IAM
  uniform_bucket_level_access = true

  # Public access prevention for security
  public_access_prevention = "enforced"

  # Soft delete policy (7 days retention for dev environment)
  soft_delete_policy {
    retention_duration_seconds = 604800 # 7 days
  }

  # Labels for cost tracking and organization
  labels = {
    environment   = "dev"
    purpose      = "application-logs"
    created-by   = "terraform"
    cost-center  = "engineering"
    project-type = "development"
  }
}

# IAM policy for service accounts to write logs
resource "google_storage_bucket_iam_member" "log_writer" {
  bucket = google_storage_bucket.terraform_test.name
  role   = "roles/storage.objectCreator"
  
  # Default compute service account can write logs
  member = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}

# Data source for default service account
data "google_compute_default_service_account" "default" {}