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
  
  # Development environment settings
  force_destroy = true  # Allow deletion of non-empty bucket in dev
  storage_class = "STANDARD"
  
  # Security: Private by default
  uniform_bucket_level_access = true
  public_access_prevention   = "enforced"
  
  # Versioning for data protection
  versioning {
    enabled = true
  }
  
  # Cost optimization for dev environment
  lifecycle_rule {
    condition {
      age = 30  # Delete objects after 30 days in dev
    }
    action {
      type = "Delete"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 7  # Move to NEARLINE after 7 days
    }
    action {
      type         = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 1  # Clean up incomplete multipart uploads
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
  
  # Soft delete policy (7 days retention)
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days
  }
  
  # Labels for cost tracking and organization
  labels = {
    environment = "development"
    purpose     = "application-logs"
    managed_by  = "terraform"
    project     = "dev-infrastructure"
    cost_center = "engineering"
  }
  
  # Enable requestor pays for cost control (optional)
  requester_pays = false  # Keep false for dev to avoid access issues
}

# IAM binding for development team access
resource "google_storage_bucket_iam_binding" "dev_access" {
  bucket = google_storage_bucket.terraform_test.name
  role   = "roles/storage.objectAdmin"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}

# Notification configuration for monitoring (optional)
resource "google_storage_notification" "log_notification" {
  bucket         = google_storage_bucket.terraform_test.name
  payload_format = "JSON_API_V1"
  topic          = var.notification_topic
  event_types    = ["OBJECT_FINALIZE", "OBJECT_DELETE"]
  
  depends_on = [google_storage_bucket.terraform_test]
  
  # Only create if notification topic is provided
  count = var.notification_topic != "" ? 1 : 0
}