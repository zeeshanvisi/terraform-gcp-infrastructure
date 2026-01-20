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

# Production GCS bucket for backup storage
resource "google_storage_bucket" "prod_backup_storage" {
  name          = var.bucket_name
  location      = var.region
  project       = var.project_id
  storage_class = "STANDARD"

  # Security: Prevent public access
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  # Versioning: Enable object versioning for backup integrity
  versioning {
    enabled = true
  }

  # Lifecycle policy: 90-day retention as requested
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  # Lifecycle policy: Clean up incomplete multipart uploads after 1 day
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Lifecycle policy: Move old versions to NEARLINE after 30 days (cost optimization)
  lifecycle_rule {
    condition {
      age       = 30
      with_state = "ARCHIVED"
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  # Soft delete policy: 7-day retention for accidental deletions
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days
  }

  # Labels for cost tracking and organization
  labels = {
    environment = "production"
    purpose     = "backup-storage"
    team        = "infrastructure"
    managed-by  = "terraform"
    cost-center = "operations"
  }

  # Force destroy for terraform cleanup (use with caution in production)
  force_destroy = false

  # Enable object retention for compliance (optional)
  enable_object_retention = false

  # Prevent accidental deletion in production
  lifecycle {
    prevent_destroy = true
  }
}