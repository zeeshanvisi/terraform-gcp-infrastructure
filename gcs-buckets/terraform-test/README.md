# Terraform Test - GCS Bucket for Application Logs

This Terraform configuration creates a Google Cloud Storage bucket optimized for development environment application logs.

## Resources Created

- **GCS Bucket**: `terraform-test`
  - Location: `us-east5`
  - Versioning: Enabled
  - Encryption: Google-managed (default)
  - Uniform bucket-level access: Enabled
  - Public access: Prevented

## Features

### Lifecycle Management
- Objects transition to NEARLINE after 30 days
- Objects transition to COLDLINE after 90 days  
- Objects are deleted after 365 days (dev environment)
- Incomplete multipart uploads are cleaned up after 7 days

### Security
- Uniform bucket-level access enabled
- Public access prevention enforced
- IAM roles configured for development team access
- Soft delete policy with 7-day retention

### Cost Optimization
- Automatic storage class transitions
- Lifecycle deletion for dev environment
- Cleanup of incomplete uploads

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## Outputs

- `bucket_name`: Name of the created bucket
- `bucket_url`: GS URL of the bucket
- `bucket_self_link`: Self link for API references
- `bucket_location`: Bucket location
- `versioning_enabled`: Confirmation of versioning status
- `public_access_prevention`: Security setting confirmation

## Environment

- **Environment**: Development
- **Purpose**: Application logs storage
- **Managed by**: Terraform
- **Auto-apply**: Enabled via Terraform Cloud

## Next Steps

1. Configure your applications to write logs to: `gs://terraform-test/`
2. Set up log rotation and structured logging in your applications
3. Consider setting up Cloud Monitoring alerts for bucket usage
4. Review lifecycle policies based on actual usage patterns

## Compliance & Security

- Encryption at rest: Google-managed keys (default)
- Access logging: Available via Cloud Audit Logs
- Data retention: Configurable via lifecycle rules
- Access control: IAM-based with uniform bucket-level access