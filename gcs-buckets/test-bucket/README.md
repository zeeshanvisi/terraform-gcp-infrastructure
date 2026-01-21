# GCS Test Bucket with Versioning

This Terraform configuration creates a simple Google Cloud Storage bucket named "test-bucket" (with a unique suffix) with versioning enabled.

## Features

- **Versioning**: Object versioning is enabled to maintain multiple versions of objects
- **Security**: Uniform bucket-level access and public access prevention enforced
- **Cost Optimization**: Lifecycle rules to clean up old versions and incomplete uploads
- **Labels**: Proper labeling for cost tracking and resource organization
- **Global Uniqueness**: Random suffix ensures bucket name is globally unique

## Resources Created

- `random_id.bucket_suffix`: Random suffix generator for unique bucket naming
- `google_storage_bucket.test_bucket`: GCS bucket with versioning and security features

## Configuration

### Bucket Settings
- Name: test-bucket-{random-suffix} (e.g., test-bucket-a1b2c3d4)
- Location: US (multi-region)
- Storage Class: STANDARD
- Versioning: Enabled
- Public Access: Prevented
- Uniform Bucket-Level Access: Enabled

### Lifecycle Rules
1. **Version Management**: Keep only the 3 most recent versions of objects
2. **Cleanup**: Delete incomplete multipart uploads after 7 days

## Variables

| Name | Description | Default |
|------|-------------|---------|
| project_id | GCP project ID | visionet-merck-poc |
| region | GCP region | us-east5 |
| bucket_name | Name of the GCS bucket (base name) | test-bucket |
| location | GCS bucket location | US |
| environment | Environment tag | development |

## Outputs

| Name | Description |
|------|-------------|
| bucket_name | Name of the created GCS bucket (with unique suffix) |
| bucket_url | URL of the created GCS bucket |
| bucket_self_link | Self-link of the created GCS bucket |
| versioning_enabled | Whether versioning is enabled |
| bucket_location | Location of the GCS bucket |
| random_suffix | Random suffix added to bucket name |

## Usage

After deployment, you can:

1. **Upload objects**: `gsutil cp file.txt gs://test-bucket-{suffix}/`
2. **List versions**: `gsutil ls -a gs://test-bucket-{suffix}/`
3. **Access specific version**: `gsutil cp gs://test-bucket-{suffix}/file.txt#<generation> ./`

## IAM Requirements

⚠️ **Important**: This Terraform configuration does not set up IAM permissions. You'll need to manually configure access:

### Required IAM Roles for Bucket Management
```bash
# For users who need to manage objects
gcloud projects add-iam-policy-binding visionet-merck-poc \
    --member="user:EMAIL" \
    --role="roles/storage.objectAdmin"

# For users who need read-only access
gcloud projects add-iam-policy-binding visionet-merck-poc \
    --member="user:EMAIL" \
    --role="roles/storage.objectViewer"
```

### Bucket-Level IAM (Alternative)
```bash
# Grant object admin access to specific bucket (replace {suffix} with actual suffix)
gsutil iam ch user:EMAIL:objectAdmin gs://test-bucket-{suffix}

# Grant viewer access to specific bucket
gsutil iam ch user:EMAIL:objectViewer gs://test-bucket-{suffix}
```

## Security Notes

- Public access is prevented by default
- Uniform bucket-level access is enabled (recommended)
- All IAM must be configured manually outside of Terraform
- Consider enabling audit logs for production use

## Deployment

This infrastructure is deployed via GitOps using:
- **GitHub Repository**: zeeshanvisi/terraform-gcp-infrastructure
- **Terraform Cloud**: Automatic plan/apply on git push
- **Working Directory**: gcs-buckets/test-bucket

## Support

For issues or questions about this infrastructure, check the Terraform Cloud workspace logs or contact the infrastructure team.
