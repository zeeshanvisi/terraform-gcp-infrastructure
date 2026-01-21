terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.16"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Generate random suffix to ensure bucket name uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Production GCS bucket for analytics data
resource "google_storage_bucket" "analytics_bucket" {
  name     = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
  location = var.region
  project  = var.project_id

  # Production settings
  force_destroy               = false  # Prevent accidental deletion
  uniform_bucket_level_access = true   # Use IAM-only access control
  public_access_prevention    = "enforced"  # Block all public access
  
  # Storage class for analytics workloads
  storage_class = "STANDARD"  # For frequently accessed analytics data

  # Versioning for data protection
  versioning {
    enabled = true
  }

  # Lifecycle management - delete objects after 90 days
  lifecycle_rule {
    condition {
      age = var.lifecycle_delete_age_days
    }
    action {
      type = "Delete"
    }
  }

  # Additional lifecycle rule for incomplete multipart uploads
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Lifecycle rule for versioned objects (non-current versions)
  lifecycle_rule {
    condition {
      age                        = var.noncurrent_version_delete_days
      with_state                = "ARCHIVED"
      matches_storage_class     = ["STANDARD"]
    }
    action {
      type = "Delete"
    }
  }

  # Soft delete policy for additional protection (7 days)
  soft_delete_policy {
    retention_duration_seconds = var.soft_delete_retention_seconds
  }

  # Labels for cost tracking and organization
  labels = {
    environment = var.environment
    purpose     = "analytics"
    team        = var.team
    cost_center = var.cost_center
    data_class  = "analytics"
    managed_by  = "terraform"
  }
}

# Create a sample folder structure for analytics data
resource "google_storage_bucket_object" "raw_data_folder" {
  name   = "raw-data/.gitkeep"
  bucket = google_storage_bucket.analytics_bucket.name
  content = "# Raw analytics data folder\n"
  content_type = "text/plain"
}

resource "google_storage_bucket_object" "processed_data_folder" {
  name   = "processed-data/.gitkeep"
  bucket = google_storage_bucket.analytics_bucket.name
  content = "# Processed analytics data folder\n"
  content_type = "text/plain"
}

resource "google_storage_bucket_object" "reports_folder" {
  name   = "reports/.gitkeep"
  bucket = google_storage_bucket.analytics_bucket.name
  content = "# Analytics reports folder\n"
  content_type = "text/plain"
}