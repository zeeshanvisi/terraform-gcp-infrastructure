output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.test_verification_bucket.name
}

output "bucket_url" {
  description = "GCS bucket URL"
  value       = google_storage_bucket.test_verification_bucket.url
}

output "bucket_self_link" {
  description = "GCS bucket self link"
  value       = google_storage_bucket.test_verification_bucket.self_link
}

output "bucket_location" {
  description = "GCS bucket location"
  value       = google_storage_bucket.test_verification_bucket.location
}
