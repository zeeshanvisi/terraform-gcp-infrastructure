output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.quick_test_bucket.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.quick_test_bucket.url
}

output "bucket_self_link" {
  description = "Self link of the GCS bucket"
  value       = google_storage_bucket.quick_test_bucket.self_link
}

output "bucket_location" {
  description = "Location of the GCS bucket"
  value       = google_storage_bucket.quick_test_bucket.location
}

output "bucket_storage_class" {
  description = "Storage class of the GCS bucket"
  value       = google_storage_bucket.quick_test_bucket.storage_class
}