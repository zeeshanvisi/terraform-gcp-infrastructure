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

# Development GCS bucket for application logs with versioning and encryption
resource "google_storage_bucket" "terraform_test" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = var.force_destroy

  # Storage class appropriate for dev logs (cost-effective)
  storage_class = "STANDARD"

  # Enable versioning for data protection
  versioning {
    enabled = true
  }

  # Development-friendly lifecycle policy (shorter retention)
  lifecycle_rule {
    condition {
      age = 30  # Delete old versions after 30 days in dev
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Public access prevention (security best practice)
  public_access_prevention = "enforced"
  
  # Uniform bucket-level access (recommended for security)
  uniform_bucket_level_access = true

  # Soft delete policy (7 days retention for dev environment)
  soft_delete_policy {
    retention_duration_seconds = 604800  # 7 days
  }

  # Labels for cost tracking and organization
  labels = {
    environment = "development"
    purpose     = "application-logs"
    team        = "devops"
    created_by  = "terraform"
  }
}

# IAM binding to allow application service account to write logs
resource "google_storage_bucket_iam_member" "log_writer" {
  bucket = google_storage_bucket.terraform_test.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${var.project_id}@appspot.gserviceaccount.com"
}

# IAM binding to allow developers to read logs
resource "google_storage_bucket_iam_member" "log_reader" {
  bucket = google_storage_bucket.terraform_test.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.project_id}@appspot.gserviceaccount.com"
}