output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.url
}

output "bucket_self_link" {
  description = "Self-link of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.self_link
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.test_bucket.versioning[0].enabled
}

output "bucket_location" {
  description = "Location of the GCS bucket"
  value       = google_storage_bucket.test_bucket.location
}
