output "bucket_name" {
  description = "The name of the created GCS bucket"
  value       = google_storage_bucket.zee_test_bucket.name
}

output "bucket_url" {
  description = "The base URL of the bucket, in the format gs://<bucket-name>"
  value       = google_storage_bucket.zee_test_bucket.url
}

output "bucket_self_link" {
  description = "The URI of the created resource"
  value       = google_storage_bucket.zee_test_bucket.self_link
}

output "bucket_location" {
  description = "The location of the bucket"
  value       = google_storage_bucket.zee_test_bucket.location
}

output "bucket_storage_class" {
  description = "The storage class of the bucket"
  value       = google_storage_bucket.zee_test_bucket.storage_class
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.zee_test_bucket.versioning[0].enabled
}

output "public_access_prevention" {
  description = "Public access prevention setting"
  value       = google_storage_bucket.zee_test_bucket.public_access_prevention
}

output "uniform_bucket_level_access" {
  description = "Whether uniform bucket-level access is enabled"
  value       = google_storage_bucket.zee_test_bucket.uniform_bucket_level_access
}

output "bucket_labels" {
  description = "Labels assigned to the bucket"
  value       = google_storage_bucket.zee_test_bucket.labels
}

output "sample_object_name" {
  description = "Name of the sample object (if created)"
  value       = var.create_sample_object ? google_storage_bucket_object.readme[0].name : null
}

# Useful for connecting to other resources
output "bucket_id" {
  description = "Bucket ID (same as name) for use in other resources"
  value       = google_storage_bucket.zee_test_bucket.id
}

output "project_number" {
  description = "The project number for reference"
  value       = google_storage_bucket.zee_test_bucket.project_number
}