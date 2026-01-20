output "bucket_name" {
  description = "The name of the created GCS bucket"
  value       = google_storage_bucket.dev_app_logs.name
}

output "bucket_url" {
  description = "The GCS URL of the bucket"
  value       = google_storage_bucket.dev_app_logs.url
}

output "bucket_self_link" {
  description = "The self link of the bucket"
  value       = google_storage_bucket.dev_app_logs.self_link
}

output "bucket_location" {
  description = "The location of the bucket"
  value       = google_storage_bucket.dev_app_logs.location
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.dev_app_logs.versioning[0].enabled
}

output "uniform_bucket_level_access" {
  description = "Whether uniform bucket-level access is enabled"
  value       = google_storage_bucket.dev_app_logs.uniform_bucket_level_access
}

output "public_access_prevention" {
  description = "Public access prevention setting"
  value       = google_storage_bucket.dev_app_logs.public_access_prevention
}

output "lifecycle_rules_summary" {
  description = "Summary of configured lifecycle rules"
  value = {
    "nearline_transition"     = "30 days"
    "coldline_transition"     = "90 days" 
    "deletion_policy"         = "365 days"
    "multipart_cleanup"       = "7 days"
  }
}

output "bucket_labels" {
  description = "Labels applied to the bucket"
  value       = google_storage_bucket.dev_app_logs.labels
}

output "soft_delete_retention" {
  description = "Soft delete retention period in seconds"
  value       = google_storage_bucket.dev_app_logs.soft_delete_policy[0].retention_duration_seconds
}