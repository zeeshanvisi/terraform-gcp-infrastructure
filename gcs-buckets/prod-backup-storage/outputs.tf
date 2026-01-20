output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.prod_backup_storage.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.prod_backup_storage.url
}

output "bucket_self_link" {
  description = "Self-link of the created GCS bucket"
  value       = google_storage_bucket.prod_backup_storage.self_link
}

output "bucket_location" {
  description = "Location of the created GCS bucket"
  value       = google_storage_bucket.prod_backup_storage.location
}

output "bucket_storage_class" {
  description = "Storage class of the created GCS bucket"
  value       = google_storage_bucket.prod_backup_storage.storage_class
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.prod_backup_storage.versioning[0].enabled
}

output "public_access_prevention" {
  description = "Public access prevention setting"
  value       = google_storage_bucket.prod_backup_storage.public_access_prevention
}

output "uniform_bucket_level_access" {
  description = "Whether uniform bucket-level access is enabled"
  value       = google_storage_bucket.prod_backup_storage.uniform_bucket_level_access
}

output "bucket_labels" {
  description = "Labels applied to the bucket"
  value       = google_storage_bucket.prod_backup_storage.labels
}

output "bucket_creation_time" {
  description = "Creation time of the bucket"
  value       = google_storage_bucket.prod_backup_storage.time_created
}

output "soft_delete_policy" {
  description = "Soft delete policy configuration"
  value = {
    retention_duration_seconds = google_storage_bucket.prod_backup_storage.soft_delete_policy[0].retention_duration_seconds
    effective_time            = google_storage_bucket.prod_backup_storage.soft_delete_policy[0].effective_time
  }
}