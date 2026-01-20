output "bucket_name" {
  description = "Name of the created bucket"
  value       = google_storage_bucket.test_bucket.name
}

output "bucket_url" {
  description = "GCS URL of the bucket"
  value       = google_storage_bucket.test_bucket.url
}

output "bucket_self_link" {
  description = "Self link of the bucket"
  value       = google_storage_bucket.test_bucket.self_link
}

output "bucket_location" {
  description = "Location of the bucket"
  value       = google_storage_bucket.test_bucket.location
}