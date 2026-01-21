terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.16.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# GCS Bucket for application logs with versioning
resource "google_storage_bucket" "terraform_test_bucket" {
  name                        = var.bucket_name
  location                    = var.location
  storage_class              = "STANDARD"
  force_destroy              = true # Dev environment - allows easy cleanup
  
  # Enable versioning for log file history
  versioning {
    enabled = true
  }
  
  # Lifecycle management for dev environment - delete old versions after 30 days
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
  
  # Lifecycle rule for incomplete multipart uploads
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
  
  # Public access prevention for security
  public_access_prevention = "enforced"
  
  # Uniform bucket-level access for simplified IAM
  uniform_bucket_level_access = true
  
  # Soft delete policy for accidental deletion protection (7 days)
  soft_delete_policy {
    retention_duration_seconds = 604800 # 7 days
  }
  
  # Labels for cost tracking and environment identification
  labels = {
    environment = "dev"
    purpose     = "application-logs"
    team        = "development"
    managed_by  = "terraform"
  }
}

# IAM binding for application service accounts to write logs
resource "google_storage_bucket_iam_binding" "log_writer" {
  bucket = google_storage_bucket.terraform_test_bucket.name
  role   = "roles/storage.objectCreator"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com", # Default App Engine SA
  ]
}

# IAM binding for developers to read logs
resource "google_storage_bucket_iam_binding" "log_reader" {
  bucket = google_storage_bucket.terraform_test_bucket.name
  role   = "roles/storage.objectViewer"
  
  members = [
    "group:developers@${var.organization_domain}", # Adjust as needed
  ]
}