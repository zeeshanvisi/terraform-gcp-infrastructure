output "bucket_name" {
  description = "Name of the created analytics bucket"
  value       = google_storage_bucket.analytics_bucket.name
}

output "bucket_url" {
  description = "URL of the created analytics bucket"
  value       = google_storage_bucket.analytics_bucket.url
}

output "bucket_self_link" {
  description = "Self link of the created analytics bucket"
  value       = google_storage_bucket.analytics_bucket.self_link
}

output "bucket_location" {
  description = "Location of the analytics bucket"
  value       = google_storage_bucket.analytics_bucket.location
}

output "bucket_id" {
  description = "ID of the analytics bucket"
  value       = google_storage_bucket.analytics_bucket.id
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket"
  value       = google_storage_bucket.analytics_bucket.versioning[0].enabled
}

output "lifecycle_rules" {
  description = "Summary of lifecycle rules applied"
  value = {
    delete_after_days = var.lifecycle_delete_age_days
    noncurrent_version_delete_days = var.noncurrent_version_delete_days
    abort_incomplete_multipart_uploads = "1 day"
  }
}

output "folder_structure" {
  description = "Created folder structure for analytics data"
  value = {
    raw_data = "${google_storage_bucket.analytics_bucket.url}/raw-data/"
    processed_data = "${google_storage_bucket.analytics_bucket.url}/processed-data/"
    reports = "${google_storage_bucket.analytics_bucket.url}/reports/"
  }
}

output "access_control" {
  description = "Summary of access control configuration"
  value = {
    uniform_bucket_level_access = google_storage_bucket.analytics_bucket.uniform_bucket_level_access
    public_access_prevention = google_storage_bucket.analytics_bucket.public_access_prevention
    iam_note = "IAM permissions can be configured post-deployment via GCP Console or gcloud CLI"
  }
}

output "security_features" {
  description = "Security features enabled on the bucket"
  value = {
    versioning = "enabled"
    soft_delete = "${var.soft_delete_retention_seconds} seconds (7 days)"
    public_access_blocked = true
    uniform_access_control = true
    force_destroy_protection = true
  }
}

output "iam_commands" {
  description = "Commands to configure IAM access post-deployment"
  value = {
    add_admin_user = "gcloud storage buckets add-iam-policy-binding gs://${google_storage_bucket.analytics_bucket.name} --member='user:your-email@domain.com' --role='roles/storage.objectAdmin'"
    add_reader_user = "gcloud storage buckets add-iam-policy-binding gs://${google_storage_bucket.analytics_bucket.name} --member='user:your-email@domain.com' --role='roles/storage.objectViewer'"
    add_service_account = "gcloud storage buckets add-iam-policy-binding gs://${google_storage_bucket.analytics_bucket.name} --member='serviceAccount:your-sa@project.iam.gserviceaccount.com' --role='roles/storage.objectAdmin'"
  }
}