output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.company_backups.name
}

output "bucket_url" {
  description = "URL of the GCS bucket"
  value       = google_storage_bucket.company_backups.url
}

output "bucket_self_link" {
  description = "Self link of the GCS bucket"
  value       = google_storage_bucket.company_backups.self_link
}

output "bucket_location" {
  description = "Location of the GCS bucket"
  value       = google_storage_bucket.company_backups.location
}

output "bucket_labels" {
  description = "Labels applied to the bucket"
  value       = google_storage_bucket.company_backups.labels
}

# Usage instructions
output "usage_instructions" {
  description = "Instructions for using the backup bucket"
  value = <<-EOT
  
  🗄️ PRODUCTION BACKUP BUCKET DEPLOYED
  
  Bucket Name: ${google_storage_bucket.company_backups.name}
  Location: ${google_storage_bucket.company_backups.location}
  
  📋 FEATURES ENABLED:
  ✅ Object versioning
  ✅ 365-day lifecycle policy
  ✅ 7-day soft delete protection
  ✅ Public access prevention
  
  📤 UPLOAD DATA:
  gsutil cp /path/to/backup gs://${google_storage_bucket.company_backups.name}/
  
  📥 RESTORE DATA:
  gsutil cp gs://${google_storage_bucket.company_backups.name}/backup-file /local/path/
  
  🔍 LIST VERSIONS:
  gsutil ls -a gs://${google_storage_bucket.company_backups.name}/
  
  ⚠️  IMPORTANT: Configure IAM permissions manually (service account lacks IAM management)
  
  EOT
}