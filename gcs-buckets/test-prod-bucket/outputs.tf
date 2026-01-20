output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.prod_bucket.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.prod_bucket.url
}

output "bucket_self_link" {
  description = "Self-link of the created GCS bucket"
  value       = google_storage_bucket.prod_bucket.self_link
}

output "audit_logs_bucket_name" {
  description = "Name of the audit logs bucket"
  value       = google_storage_bucket.audit_logs.name
}

output "bucket_location" {
  description = "Location of the bucket"
  value       = google_storage_bucket.prod_bucket.location
}

output "bucket_storage_class" {
  description = "Storage class of the bucket"
  value       = google_storage_bucket.prod_bucket.storage_class
}

output "notification_topic" {
  description = "Pub/Sub topic for bucket notifications"
  value       = google_pubsub_topic.bucket_notifications.name
}

output "retention_policy" {
  description = "Retention policy configuration"
  value = {
    retention_days = var.retention_days
    versioning_enabled = true
  }
}

output "security_features" {
  description = "Security features enabled on the bucket"
  value = {
    uniform_bucket_level_access = true
    public_access_prevention = "enforced"
    versioning_enabled = true
    audit_logging_enabled = true
  }
}