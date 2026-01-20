output "bucket_name" {
  description = "The name of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.name
}

output "bucket_url" {
  description = "The URL of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.url
}

output "bucket_self_link" {
  description = "The self-link of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.self_link
}

output "bucket_location" {
  description = "The location of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.location
}
