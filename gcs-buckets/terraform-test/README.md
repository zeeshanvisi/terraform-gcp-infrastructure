# Terraform Test - GCS Bucket for Application Logs

This Terraform configuration creates a Google Cloud Storage (GCS) bucket specifically designed for storing application logs in a development environment.

## Features

- **Versioning Enabled**: Object versioning is enabled to maintain historical versions of log files
- **Encryption**: Uses Google-managed encryption keys (default encryption) 
- **Lifecycle Management**: Automatic cost optimization through storage class transitions
- **Security**: 
  - Uniform bucket-level access enabled
  - Public access prevention enforced
  - IAM permissions for service account log writing
- **Cost Optimization**:
  - 30 days: Move to NEARLINE storage
  - 90 days: Move to COLDLINE storage  
  - 365 days: Delete old logs
- **Soft Delete**: 7-day retention for accidentally deleted objects

## Resources Created

- `google_storage_bucket.terraform_test` - The main GCS bucket
- `google_storage_bucket_iam_member.log_writer` - IAM binding for log writing access
- `data.google_compute_default_service_account.default` - Reference to default service account

## Deployment

This infrastructure is deployed using GitOps workflow:

1. **Code pushed to GitHub**: `zeeshanvisi/terraform-gcp-infrastructure`
2. **Terraform Cloud workspace**: `terraform-test-bucket-workspace`
3. **Working directory**: `gcs-buckets/terraform-test`
4. **Auto-apply enabled**: Changes automatically deployed

## Configuration

### Default Values
- **Bucket Name**: `terraform-test`
- **Location**: `us-east5` 
- **Project**: `visionet-merck-poc`
- **Environment**: `dev`

### Customization
To customize the bucket configuration, update the variables in `variables.tf` or override them in your Terraform Cloud workspace variables.

## Usage Examples

### Upload application logs
```bash
# Using gsutil
gsutil cp application.log gs://terraform-test/logs/$(date +%Y/%m/%d)/

# Using curl with service account
curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/octet-stream" \
  --data-binary @application.log \
  "https://storage.googleapis.com/upload/storage/v1/b/terraform-test/o?uploadType=media&name=logs/$(date +%Y/%m/%d)/application.log"
```

### Access logs programmatically
```python
from google.cloud import storage

client = storage.Client(project='visionet-merck-poc')
bucket = client.bucket('terraform-test')

# List log files
for blob in bucket.list_blobs(prefix='logs/'):
    print(f"Log file: {blob.name}, Size: {blob.size}")
```

## Monitoring & Alerting

Consider setting up:
- **Cloud Logging**: Monitor bucket access and operations
- **Cloud Monitoring**: Track storage usage and costs
- **Pub/Sub notifications**: Get notified of new log uploads

## Cost Optimization

This bucket is configured with lifecycle policies to optimize storage costs:
- Logs automatically move to cheaper storage classes over time
- Old logs are automatically deleted after 1 year
- Incomplete multipart uploads are cleaned up daily

## Security Considerations

- Bucket uses uniform bucket-level access (no legacy ACLs)
- Public access is prevented at the bucket level
- Default compute service account has object creation permissions
- All data encrypted at rest with Google-managed keys

## Next Steps

1. Configure application logging to write to this bucket
2. Set up log processing pipeline (e.g., Cloud Functions, Dataflow)
3. Configure monitoring and alerting
4. Review and adjust lifecycle policies based on retention requirements