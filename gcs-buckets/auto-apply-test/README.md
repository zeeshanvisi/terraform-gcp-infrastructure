# Test GCS Bucket - auto-apply-test-bucket-001

This Terraform configuration creates a test GCS bucket in Google Cloud Platform.

## Resources Created

- **GCS Bucket**: `auto-apply-test-bucket-001`
  - Location: `us-west2`
  - Storage Class: `STANDARD`
  - Uniform bucket-level access: Enabled
  - Auto-cleanup: Objects deleted after 30 days

## Configuration Details

### Test Environment Optimizations
- **Force Destroy**: Enabled for easy cleanup
- **Lifecycle Rules**: 
  - Delete objects after 30 days
  - Abort incomplete multipart uploads after 1 day
- **Versioning**: Disabled to reduce costs
- **Labels**: Applied for tracking and cost management

### Security Features
- Uniform bucket-level access enforced
- Default Google-managed encryption
- Private by default (no public access)

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| project_id | GCP project ID | string | "visionet-merck-poc" |
| region | GCP region for the bucket | string | "us-west2" |
| bucket_name | Name of the GCS bucket | string | "auto-apply-test-bucket-001" |
| environment | Environment name | string | "test" |

## Outputs

| Name | Description |
|------|-----------|
| bucket_name | Name of the created GCS bucket |
| bucket_url | URL of the created GCS bucket |
| bucket_self_link | Self-link of the created GCS bucket |
| bucket_location | Location of the created GCS bucket |
| bucket_storage_class | Storage class of the created GCS bucket |

## Usage

This configuration is deployed automatically via GitOps through:
1. **GitHub Repository**: `zeeshanvisi/terraform-gcp-infrastructure`
2. **Terraform Cloud Workspace**: `test-gcs-bucket-workspace`
3. **Working Directory**: `gcs-buckets/auto-apply-test`

### Manual Commands (if needed)
```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply

# Clean up resources
terraform destroy
```

## Cost Optimization

This test environment includes several cost optimization features:
- Object lifecycle management (30-day deletion)
- Versioning disabled
- Automatic cleanup of incomplete uploads
- Appropriate labels for cost tracking

## Next Steps

After successful deployment, you can:
1. Upload test files to verify functionality
2. Test access controls and permissions
3. Monitor costs and usage patterns
4. Scale to production configuration when ready

## Support

For issues or questions, contact the infrastructure team or check the Terraform Cloud workspace logs.