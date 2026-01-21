output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.application_logs.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.application_logs.url
}

output "bucket_self_link" {
  description = "Self-link of the created GCS bucket"
  value       = google_storage_bucket.application_logs.self_link
}

output "bucket_location" {
  description = "Location of the created GCS bucket"
  value       = google_storage_bucket.application_logs.location
}

output "bucket_storage_class" {
  description = "Storage class of the created GCS bucket"
  value       = google_storage_bucket.application_logs.storage_class
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.application_logs.versioning[0].enabled
}

output "public_access_prevention" {
  description = "Public access prevention setting"
  value       = google_storage_bucket.application_logs.public_access_prevention
}