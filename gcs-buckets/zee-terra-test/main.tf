terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.16"
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

# Generate unique suffix for bucket name to ensure global uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Production GCS bucket for application logs
resource "google_storage_bucket" "application_logs" {
  name     = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
  location = var.location

  # Production-grade settings
  storage_class            = "STANDARD"
  force_destroy           = false
  uniform_bucket_level_access = true
  public_access_prevention = "enforced"

  # Versioning for data integrity and recovery
  versioning {
    enabled = true
  }

  # Lifecycle rules for log retention and cost optimization
  lifecycle_rule {
    condition {
      age = 90  # Archive logs after 90 days
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365  # Delete logs after 1 year (adjust per compliance requirements)
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1  # Clean up incomplete multipart uploads after 1 day
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 5  # Keep only 5 versions per object
    }
    action {
      type = "Delete"
    }
  }

  # Soft delete policy for accidental deletion protection
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days retention
  }

  # Labels for cost tracking and organization
  labels = {
    environment = var.environment
    purpose     = "application-logs"
    team        = var.team
    cost-center = var.cost_center
    managed-by  = "terraform"
  }

  # Note: Audit logging removed to prevent dependency issues
  # Configure access logging manually if needed after bucket creation
}

# 🚨 CRITICAL: NO IAM CONFIGURATION 🚨
# Service account lacks IAM permissions - IAM configuration must be done manually
# See README.md for required IAM permissions and setup instructions