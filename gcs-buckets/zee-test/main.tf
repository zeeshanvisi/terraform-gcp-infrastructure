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

# GCS bucket for development application logs
resource "google_storage_bucket" "zee_test_logs" {
  name          = "zee-test"
  location      = var.region
  project       = var.project_id
  force_destroy = true  # Safe for dev environment
  
  # Storage class optimized for frequently accessed logs
  storage_class = "STANDARD"
  
  # Enable versioning for log file history
  versioning {
    enabled = true
  }
  
  # Lifecycle management for cost optimization in dev
  lifecycle_rule {
    condition {
      age = 30  # Delete logs older than 30 days in dev
    }
    action {
      type = "Delete"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 7  # Move to Nearline after 7 days to save costs
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 1  # Clean up incomplete uploads after 1 day
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
  
  # Public access prevention for security
  public_access_prevention = "enforced"
  
  # Uniform bucket-level access for simplified IAM
  uniform_bucket_level_access = true
  
  # Soft delete policy for accidental deletion protection
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days retention
  }
  
  # Labels for resource management and cost tracking
  labels = {
    environment = "dev"
    purpose     = "application-logs"
    team        = "development"
    managed-by  = "terraform"
    created-by  = "gcp-terraform-agent"
  }
}

# IAM binding for application service accounts to write logs
resource "google_storage_bucket_iam_binding" "log_writers" {
  bucket = google_storage_bucket.zee_test_logs.name
  role   = "roles/storage.objectCreator"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",  # Default App Engine SA
    "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com",  # Default Compute SA
  ]
}

# IAM binding for development team to read logs
resource "google_storage_bucket_iam_binding" "log_readers" {
  bucket = google_storage_bucket.zee_test_logs.name
  role   = "roles/storage.objectViewer"
  
  members = [
    "group:developers@visionet.com",  # Replace with actual dev team group
  ]
}