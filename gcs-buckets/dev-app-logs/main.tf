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

# Random suffix for globally unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Development GCS bucket for application logs
resource "google_storage_bucket" "dev_app_logs" {
  name          = "${var.project_id}-dev-app-logs-${random_id.bucket_suffix.hex}"
  location      = var.region
  storage_class = "STANDARD"  # Good for frequently accessed logs
  
  # Enable uniform bucket-level access for better security
  uniform_bucket_level_access = true
  
  # Prevent accidental deletion for dev environment
  force_destroy = true
  
  # Public access prevention for security
  public_access_prevention = "enforced"
  
  # Enable versioning for log file recovery
  versioning {
    enabled = true
  }
  
  # Lifecycle management for cost optimization
  lifecycle_rule {
    condition {
      age = 30  # Move to Nearline after 30 days
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 90  # Move to Coldline after 90 days
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
  
  # Clean up incomplete multipart uploads
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
  
  # Soft delete policy for recovery (7 days retention)
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days
  }
  
  # Labels for cost tracking and organization
  labels = {
    environment = "dev"
    purpose     = "application-logs"
    managed-by  = "terraform"
    team        = "devops"
  }
}