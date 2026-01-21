# Terraform Test - Development GCS Bucket

This Terraform configuration creates a Google Cloud Storage bucket optimized for development environment application logs.

## Resources Created

- **GCS Bucket**: `terraform-test` with versioning and lifecycle policies
- **IAM Binding**: Service account access for object administration
- **Notification**: Optional Pub/Sub notifications for bucket events

## Features

### Security
- ✅ Private bucket (public access prevention enforced)
- ✅ Uniform bucket-level access enabled
- ✅ Google-managed encryption (default)
- ✅ Service account-based access control

### Data Management
- ✅ **Versioning enabled** - Previous versions of objects are retained
- ✅ **Lifecycle policies**:
  - Objects moved to NEARLINE storage after 7 days
  - Objects deleted after 30 days (cost optimization for dev)
  - Incomplete multipart uploads cleaned up after 1 day
- ✅ **Soft delete** - 7 days retention for deleted objects

### Cost Optimization
- ✅ Automatic storage class transitions
- ✅ Lifecycle deletion for old objects
- ✅ Proper labeling for cost tracking

## Usage

### Deploy Infrastructure
```bash
# The GitOps workflow automatically deploys when code is pushed to GitHub
# Terraform Cloud VCS integration handles plan and apply
```

### Access the Bucket
```bash
# List bucket contents
gsutil ls gs://terraform-test/

# Upload log files
gsutil cp application.log gs://terraform-test/logs/

# View versioned objects
gsutil ls -a gs://terraform-test/logs/
```

### Monitor Costs
All resources are labeled for cost tracking:
- `environment`: development
- `purpose`: application-logs
- `managed_by`: terraform

## Configuration

### Variables
- `bucket_name`: Name of the GCS bucket (default: "terraform-test")
- `region`: GCP region (default: "us-east5")
- `project_id`: GCP project (default: "visionet-merck-poc")

### Lifecycle Policies
- **NEARLINE transition**: 7 days
- **Deletion**: 30 days
- **Incomplete uploads cleanup**: 1 day

## Best Practices Applied

1. **Security First**: Private by default, no public access
2. **Cost Optimization**: Automatic lifecycle management
3. **Data Protection**: Versioning and soft delete enabled
4. **Monitoring**: Structured labeling for tracking
5. **Development-Friendly**: Force destroy enabled for easy cleanup

## Terraform Cloud Integration

This infrastructure is managed through:
- **Repository**: `zeeshanvisi/terraform-gcp-infrastructure`
- **Working Directory**: `gcs-buckets/terraform-test`
- **Workspace**: `terraform-test-dev-bucket`
- **Auto-apply**: Enabled for development workflow

## Next Steps

1. Upload application logs to the bucket
2. Set up log forwarding from your applications
3. Configure monitoring and alerting
4. Review cost optimization after initial usage
5. Consider promoting to staging environment when ready

## Cleanup

To destroy the infrastructure:
```bash
# In Terraform Cloud workspace, queue a destroy plan
# Or via CLI (if configured):
terraform destroy
```

**Note**: Force destroy is enabled, so the bucket will be deleted even if it contains objects.