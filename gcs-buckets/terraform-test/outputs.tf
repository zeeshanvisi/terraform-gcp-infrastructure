output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.terraform_test_bucket.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.terraform_test_bucket.url
}

output "bucket_self_link" {
  description = "Self-link of the created GCS bucket"
  value       = google_storage_bucket.terraform_test_bucket.self_link
}

output "bucket_location" {
  description = "Location of the created GCS bucket"
  value       = google_storage_bucket.terraform_test_bucket.location
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.terraform_test_bucket.versioning[0].enabled
}

output "uniform_bucket_level_access" {
  description = "Whether uniform bucket-level access is enabled"
  value       = google_storage_bucket.terraform_test_bucket.uniform_bucket_level_access
}

# Useful information for application integration
output "bucket_gsutil_uri" {
  description = "gsutil URI for the bucket"
  value       = "gs://${google_storage_bucket.terraform_test_bucket.name}"
}

output "deployment_info" {
  description = "Deployment information and usage instructions"
  value = {
    bucket_name = google_storage_bucket.terraform_test_bucket.name
    environment = "development"
    features = [
      "versioning_enabled",
      "public_access_prevention",
      "uniform_bucket_level_access",
      "soft_delete_policy",
      "lifecycle_management"
    ]
    recommended_usage = "Store application logs with automatic lifecycle management"
  }
}