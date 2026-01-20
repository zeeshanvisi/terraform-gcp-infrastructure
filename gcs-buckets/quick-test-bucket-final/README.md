# Quick Test GCS Bucket

This Terraform configuration creates a small test GCS bucket named `quick-test-bucket-final` in the `us-central1` region.

## Resources Created

- **Google Cloud Storage Bucket**: A secure, test-optimized bucket with:
  - Standard storage class for immediate access
  - Uniform bucket-level access enabled
  - Public access prevention enforced
  - Automatic cleanup after 30 days
  - Soft delete policy (7-day retention)
  - Cost tracking labels

## Configuration

### Variables
- `project_id`: GCP project ID (default: visionet-merck-poc)
- `region`: GCP region (default: us-central1)
- `bucket_name`: Bucket name (default: quick-test-bucket-final)

### Security Features
- Uniform bucket-level access for simplified IAM
- Public access prevention to avoid accidental exposure
- Proper GCS best practices

### Test-Friendly Features
- `force_destroy = true` for easy cleanup
- Auto-deletion of objects after 30 days
- Abort incomplete uploads after 1 day
- Soft delete policy for recovery

## Usage

This bucket is designed for:
- Quick testing and experimentation
- Temporary data storage
- Development workloads
- CI/CD artifacts with automatic cleanup

## Outputs

- `bucket_name`: The bucket name
- `bucket_url`: The gs:// URL
- `bucket_self_link`: Full GCS API URL
- `bucket_location`: Bucket location
- `bucket_storage_class`: Storage class

## Deployed via GitOps

This infrastructure is deployed using:
- **GitHub Repository**: zeeshanvisi/terraform-gcp-infrastructure
- **Working Directory**: gcs-buckets/quick-test-bucket-final
- **Terraform Cloud**: Visionetpvt organization
- **Workspace**: quick-test-bucket-final-workspace

Any changes pushed to the GitHub repository will automatically trigger a new Terraform plan.