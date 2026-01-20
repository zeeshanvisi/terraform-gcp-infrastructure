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

# Generate timestamp for unique bucket naming
locals {
  timestamp = formatdate("YYYYMMDD-hhmmss", timestamp())
  bucket_name = "${var.bucket_name_prefix}-${local.timestamp}"
}

# Production GCS bucket with comprehensive configuration
resource "google_storage_bucket" "prod_bucket" {
  name          = local.bucket_name
  project       = var.project_id
  location      = var.region
  force_destroy = false # Prevent accidental deletion in production
  
  # Storage class for production workloads
  storage_class = "STANDARD"
  
  # Enable uniform bucket-level access for better security
  uniform_bucket_level_access = true
  
  # Enable versioning for data protection
  versioning {
    enabled = true
  }
  
  # Lifecycle management with 90-day retention
  lifecycle_rule {
    condition {
      age = var.retention_days
    }
    action {
      type = "Delete"
    }
  }
  
  # Lifecycle rule for non-current versions (cleanup after 30 days)
  lifecycle_rule {
    condition {
      days_since_noncurrent_time = 30
    }
    action {
      type = "Delete"
    }
  }
  
  # Public access prevention for security
  public_access_prevention = "enforced"
  
  # Labels for cost tracking and organization
  labels = {
    environment = "production"
    purpose     = "data-storage"
    managed-by  = "terraform"
    retention   = "90-days"
    cost-center = "infrastructure"
  }
  
  # Audit logging configuration
  logging {
    log_bucket = google_storage_bucket.audit_logs.name
  }
}

# Separate bucket for audit logs
resource "google_storage_bucket" "audit_logs" {
  name          = "${local.bucket_name}-audit-logs"
  project       = var.project_id
  location      = var.region
  force_destroy = false
  
  storage_class = "NEARLINE" # Cost-effective for logs
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = false # Not needed for logs
  }
  
  # Longer retention for audit logs (7 years for compliance)
  lifecycle_rule {
    condition {
      age = 2555 # 7 years
    }
    action {
      type = "Delete"
    }
  }
  
  public_access_prevention = "enforced"
  
  labels = {
    environment = "production"
    purpose     = "audit-logs"
    managed-by  = "terraform"
    retention   = "7-years"
  }
}

# IAM binding for production access control
resource "google_storage_bucket_iam_binding" "prod_bucket_admin" {
  bucket = google_storage_bucket.prod_bucket.name
  role   = "roles/storage.admin"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}

# IAM binding for read-only access (for applications)
resource "google_storage_bucket_iam_binding" "prod_bucket_viewer" {
  bucket = google_storage_bucket.prod_bucket.name
  role   = "roles/storage.objectViewer"
  
  members = [
    "serviceAccount:${var.project_id}@appspot.gserviceaccount.com",
  ]
}

# Notification configuration for monitoring
resource "google_storage_notification" "bucket_notification" {
  bucket         = google_storage_bucket.prod_bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.bucket_notifications.id
  event_types    = ["OBJECT_FINALIZE", "OBJECT_DELETE"]
  
  depends_on = [google_pubsub_topic_iam_binding.binding]
}

# Pub/Sub topic for bucket notifications
resource "google_pubsub_topic" "bucket_notifications" {
  name    = "${local.bucket_name}-notifications"
  project = var.project_id
  
  labels = {
    environment = "production"
    purpose     = "bucket-notifications"
    managed-by  = "terraform"
  }
}

# IAM for Cloud Storage to publish to Pub/Sub
data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

resource "google_pubsub_topic_iam_binding" "binding" {
  topic   = google_pubsub_topic.bucket_notifications.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}