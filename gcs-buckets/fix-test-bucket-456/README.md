# GCS Test Bucket: fix-test-bucket-456

This Terraform configuration creates a simple test GCS bucket in Google Cloud Platform.

## Resources Created

- **Google Storage Bucket**: `fix-test-bucket-456`
  - Location: `us-central1`
  - Storage class: `STANDARD`
  - Public access: `Prevented`
  - Uniform bucket-level access: `Enabled`

## Configuration

### Variables
- `project_id`: GCP project ID (default: "visionet-merck-poc")
- `region`: GCP region (default: "us-central1")
- `bucket_name`: Bucket name (default: "fix-test-bucket-456")

### Security Features
- Public access prevention enforced
- Uniform bucket-level access enabled
- Force destroy enabled for testing purposes

## Deployment

This bucket is deployed via GitOps workflow:
1. Code pushed to GitHub repository
2. Terraform Cloud VCS integration triggers automatically
3. Plan and apply executed in Terraform Cloud

## Usage

After deployment, you can:
```bash
# Upload files
gsutil cp file.txt gs://fix-test-bucket-456/

# List contents
gsutil ls gs://fix-test-bucket-456/

# Download files
gsutil cp gs://fix-test-bucket-456/file.txt .
```

## Cleanup

To destroy this test bucket:
1. Go to Terraform Cloud workspace: `test-bucket-fix-test`
2. Queue a destroy plan
3. Approve and apply the destroy

**Note**: `force_destroy = true` allows deletion even if bucket contains objects.