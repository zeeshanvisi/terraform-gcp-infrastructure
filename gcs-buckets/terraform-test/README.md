# Terraform Test - Development GCS Bucket

**Last Updated: TIMESTAMP_PLACEHOLDER**

This Terraform configuration creates a development GCS bucket for application logs with versioning and encryption.

## Resources Created

- **GCS Bucket**: `terraform-test` with versioning enabled
- **IAM Permissions**: Service account access for log writing and reading
- **Lifecycle Policies**: 30-day retention for development environment
- **Security**: Public access prevention and uniform bucket-level access

## Features

### Security
- ✅ Public access prevention enforced
- ✅ Uniform bucket-level access enabled
- ✅ Encryption at rest (Google-managed keys by default)
- ✅ IAM-based access control

### Data Protection
- ✅ Versioning enabled for data protection
- ✅ Soft delete policy (7 days retention)
- ✅ Lifecycle rules to manage storage costs

### Development-Friendly
- ✅ Force destroy enabled for easy cleanup
- ✅ Shorter retention periods (30 days)
- ✅ Cost-effective storage class

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `project_id` | GCP project ID | `visionet-merck-poc` |
| `region` | GCP region | `us-east5` |
| `bucket_name` | Bucket name | `terraform-test` |
| `force_destroy` | Allow force destroy | `true` |

## Usage

This bucket is designed for application logs in development environment:

```bash
# Upload log files
gsutil cp app.log gs://terraform-test/logs/

# List bucket contents
gsutil ls gs://terraform-test/

# View bucket info
gsutil ls -L -b gs://terraform-test/
```

## Outputs

- `bucket_name`: The name of the created bucket
- `bucket_url`: Full GCS URL of the bucket
- `bucket_location`: Geographic location
- `versioning_enabled`: Confirmation that versioning is active

## Deployment

This configuration is deployed via GitOps workflow:
1. Code pushed to GitHub repository
2. Terraform Cloud VCS integration detects changes
3. Automatic plan and apply executed
4. Teams notification sent on completion

## Notes

- Encryption is handled automatically by Google Cloud (no additional configuration needed)
- The bucket includes development-appropriate lifecycle policies
- IAM permissions are set for typical application logging use cases
- Monitoring labels are applied for cost tracking and organization
