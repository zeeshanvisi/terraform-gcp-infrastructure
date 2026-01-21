terraform {
  required_version ">= 1.0"
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

# Generate random suffix to ensure bucket name is globally unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Simple GCS bucket with versioning enabled
resource "google_storage_bucket" "test_bucket" {
  name     = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
  location = var.location
  project  = var.project_id

  # Force destroy for dev/test purposes - allows deletion even with objects
  force_destroy = true

  # Storage class for standard access
  storage_class = "STANDARD"

  # Enable versioning
  versioning {
    enabled = true
  }

  # Security: Uniform bucket-level access
  uniform_bucket_level_access = true

  # Security: Prevent public access
  public_access_prevention = "enforced"

  # Lifecycle rule to clean up old versions (optional, good practice)
  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }

  # Cost optimization: Delete incomplete multipart uploads
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  # Labels for cost tracking and organization
  labels = {
    environment = var.environment
    purpose     = "test-bucket"
    managed_by  = "terraform"
  }
}
