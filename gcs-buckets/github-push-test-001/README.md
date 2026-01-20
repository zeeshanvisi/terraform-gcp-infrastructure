# Test GCS Bucket: github-push-test-001

This is a test GCS bucket created to validate the GitHub push and Terraform Cloud VCS integration workflow.

## Configuration

- **Bucket Name**: `github-push-test-001`
- **Location**: `us-central1`
- **Storage Class**: `STANDARD`
- **Access**: Private (uniform bucket-level access enabled)
- **Lifecycle**: Objects deleted after 7 days
- **Soft Delete**: 7-day retention for accidental deletion protection

## Features

- ✅ Uniform bucket-level access for simplified IAM
- ✅ Public access prevention enforced
- ✅ Automatic cleanup after 7 days for cost optimization
- ✅ Soft delete protection
- ✅ Cost tracking labels

## Usage

This bucket is intended for testing purposes only. Data will be automatically deleted after 7 days.

```bash
# Upload a test file
gsutil cp test-file.txt gs://github-push-test-001/

# List bucket contents
gsutil ls gs://github-push-test-001/

# Download file
gsutil cp gs://github-push-test-001/test-file.txt ./downloaded-file.txt
```

## Terraform Outputs

After deployment, the following outputs will be available:
- `bucket_name`: The name of the bucket
- `bucket_url`: The bucket URL
- `bucket_self_link`: Full resource self-link
- `bucket_location`: Bucket location

## Cleanup

Files are automatically deleted after 7 days. To destroy the bucket infrastructure:

1. Go to Terraform Cloud workspace: `github-push-test-001-workspace`
2. Queue a destroy plan
3. Apply the destroy plan

---
*Created by GCP Terraform Agent via GitOps workflow*
