output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.terraform_test.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.terraform_test.url
}

output "bucket_self_link" {
  description = "Self link of the created GCS bucket"
  value       = google_storage_bucket.terraform_test.self_link
}

output "bucket_location" {
  description = "Location of the created GCS bucket"
  value       = google_storage_bucket.terraform_test.location
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.terraform_test.versioning[0].enabled
}

output "uniform_bucket_level_access" {
  description = "Whether uniform bucket-level access is enabled"
  value       = google_storage_bucket.terraform_test.uniform_bucket_level_access
}

output "public_access_prevention" {
  description = "Public access prevention setting"
  value       = google_storage_bucket.terraform_test.public_access_prevention
}

output "storage_class" {
  description = "Storage class of the bucket"
  value       = google_storage_bucket.terraform_test.storage_class
}

output "time_created" {
  description = "Creation time of the bucket"
  value       = google_storage_bucket.terraform_test.time_created
}

output "soft_delete_retention_days" {
  description = "Soft delete retention period in days"
  value       = google_storage_bucket.terraform_test.soft_delete_policy[0].retention_duration_seconds / 86400
}