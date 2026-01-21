output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.zee_test_logs.name
}

output "bucket_url" {
  description = "GCS URL of the bucket"
  value       = google_storage_bucket.zee_test_logs.url
}

output "bucket_self_link" {
  description = "Self link of the bucket"
  value       = google_storage_bucket.zee_test_logs.self_link
}

output "bucket_location" {
  description = "Location of the bucket"
  value       = google_storage_bucket.zee_test_logs.location
}

output "bucket_storage_class" {
  description = "Storage class of the bucket"
  value       = google_storage_bucket.zee_test_logs.storage_class
}

output "versioning_enabled" {
  description = "Whether versioning is enabled"
  value       = google_storage_bucket.zee_test_logs.versioning[0].enabled
}

output "public_access_prevention" {
  description = "Public access prevention setting"
  value       = google_storage_bucket.zee_test_logs.public_access_prevention
}

output "bucket_labels" {
  description = "Labels applied to the bucket"
  value       = google_storage_bucket.zee_test_logs.labels
}