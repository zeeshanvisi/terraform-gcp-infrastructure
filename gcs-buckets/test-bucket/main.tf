terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.16"
    }
  }
}

# Minimal GCS bucket with versioning
resource "google_storage_bucket" "test_bucket" {
  name          = "visionet-merck-test-bucket-2024-01-21"
  location      = "US"
  project       = "visionet-merck-poc"
  force_destroy = true

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
  public_access_prevention = "enforced"
}
