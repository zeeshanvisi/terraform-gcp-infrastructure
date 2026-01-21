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

output "public_access_prevention" {
  description = "Public access prevention setting"
  value       = google_storage_bucket.terraform_test.public_access_prevention
}

output "uniform_bucket_level_access" {
  description = "Whether uniform bucket level access is enabled"
  value       = google_storage_bucket.terraform_test.uniform_bucket_level_access
}

output "random_suffix" {
  description = "Random suffix added to bucket name for uniqueness"
  value       = random_id.bucket_suffix.hex
}