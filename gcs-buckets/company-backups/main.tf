terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Generate random suffix for bucket name uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Production GCS bucket for critical backups
resource "google_storage_bucket" "company_backups" {
  name     = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
  location = var.location

  # Uniform bucket-level access for security
  uniform_bucket_level_access = true

  # Versioning for data protection
  versioning {
    enabled = true
  }

  # Lifecycle management - delete objects after 365 days
  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }

  # Additional lifecycle rule for non-current versions (older than 30 days)
  lifecycle_rule {
    condition {
      age                        = 30
      with_state                = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }

  # Soft delete policy for accidental deletion protection
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days
  }

  # Public access prevention
  public_access_prevention = "enforced"

  # Labels for cost tracking and organization
  labels = {
    environment = "production"
    purpose     = "backup"
    criticality = "high"
    managed_by  = "terraform"
    cost_center = "infrastructure"
  }

  # Force destroy for cleanup (be careful in production)
  force_destroy = false
}

# Notification configuration for monitoring (optional)
resource "google_storage_notification" "backup_notification" {
  bucket         = google_storage_bucket.company_backups.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.backup_notifications.id
  event_types    = ["OBJECT_FINALIZE", "OBJECT_DELETE"]

  depends_on = [google_pubsub_topic_iam_member.binding]
}

# Pub/Sub topic for bucket notifications
resource "google_pubsub_topic" "backup_notifications" {
  name = "${var.bucket_name}-notifications-${random_id.bucket_suffix.hex}"

  labels = {
    environment = "production"
    purpose     = "backup-monitoring"
  }
}

# Required IAM for Cloud Storage to publish to Pub/Sub
data "google_storage_project_service_account" "gcs_account" {
}

resource "google_pubsub_topic_iam_member" "binding" {
  topic  = google_pubsub_topic.backup_notifications.id
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}