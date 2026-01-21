output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.terraform_test.name
}

output "bucket_url" {
  description = "GCS bucket URL"
  value       = google_storage_bucket.terraform_test.url
}

output "bucket_self_link" {
  description = "Self-link of the bucket"
  value       = google_storage_bucket.terraform_test.self_link
}

output "bucket_location" {
  description = "Location of the bucket"
  value       = google_storage_bucket.terraform_test.location
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.terraform_test.versioning[0].enabled
}