# Production Analytics Data GCS Bucket

## Overview
This Terraform configuration creates a production-grade Google Cloud Storage bucket specifically designed for analytics data storage. The bucket includes comprehensive security, lifecycle management, and access control features.

## Features

### 🔒 Security
- **Uniform bucket-level access**: Uses IAM-only access control (no legacy ACLs)
- **Public access prevention**: Enforced to block all public access
- **Versioning enabled**: Protects against accidental deletions/modifications
- **Soft delete policy**: 7-day retention for accidentally deleted objects
- **Force destroy protection**: Prevents accidental bucket deletion

### 📊 Data Management
- **Lifecycle policies**:
  - Delete objects after 90 days
  - Delete non-current versions after 30 days
  - Abort incomplete multipart uploads after 1 day
- **Organized folder structure**:
  - `raw-data/` - For incoming raw analytics data
  - `processed-data/` - For processed/transformed data
  - `reports/` - For generated analytics reports

### 👥 Access Control
- **IAM-based access control** (configured separately)
- **No default permissions** (secure by default)
- **Post-deployment IAM setup** required (see commands below)

### 🏷️ Cost Management
- Comprehensive labeling for cost tracking
- Standard storage class for frequently accessed data
- Lifecycle rules to automatically clean up old data

## Deployed Resources

1. **google_storage_bucket.analytics_bucket** - Main analytics data bucket
2. **google_storage_bucket_object.*** - Folder structure placeholders
3. **random_id.bucket_suffix** - Ensures unique bucket naming

## Post-Deployment IAM Setup

After the bucket is created, configure IAM permissions using these commands:

### Add Analytics Team Admin Access
```bash
# Replace with actual user/group email
gcloud storage buckets add-iam-policy-binding gs://[BUCKET_NAME] \
  --member='user:analytics-lead@visionet.com' \
  --role='roles/storage.objectAdmin'

# For a Google Group
gcloud storage buckets add-iam-policy-binding gs://[BUCKET_NAME] \
  --member='group:analytics-team@visionet.com' \
  --role='roles/storage.objectAdmin'
```

### Add Read-Only Access for Data Scientists
```bash
gcloud storage buckets add-iam-policy-binding gs://[BUCKET_NAME] \
  --member='group:data-scientists@visionet.com' \
  --role='roles/storage.objectViewer'
```

### Add Service Account Access
```bash
gcloud storage buckets add-iam-policy-binding gs://[BUCKET_NAME] \
  --member='serviceAccount:analytics-service@visionet-merck-poc.iam.gserviceaccount.com' \
  --role='roles/storage.objectAdmin'
```

## Usage

### Uploading Data
```bash
# Upload raw data
gsutil cp analytics_data.csv gs://[BUCKET_NAME]/raw-data/

# Upload processed data
gsutil cp processed_data.parquet gs://[BUCKET_NAME]/processed-data/

# Upload reports
gsutil cp monthly_report.pdf gs://[BUCKET_NAME]/reports/
```

### Access via Python
```python
from google.cloud import storage

client = storage.Client()
bucket = client.bucket('[BUCKET_NAME]')

# List objects in raw-data folder
blobs = bucket.list_blobs(prefix='raw-data/')
for blob in blobs:
    print(f"Found: {blob.name}")

# Download a file
blob = bucket.blob('processed-data/my-file.csv')
blob.download_to_filename('local-file.csv')
```

### BigQuery Integration
```sql
-- Load data from GCS into BigQuery
LOAD DATA INTO `project.dataset.table`
FROM FILES (
  format = 'CSV',
  uris = ['gs://[BUCKET_NAME]/processed-data/*.csv']
);
```

## Configuration

### Key Variables
- `lifecycle_delete_age_days`: 90 (delete objects after 90 days)
- `noncurrent_version_delete_days`: 30 (delete old versions after 30 days)
- `soft_delete_retention_seconds`: 604800 (7 days)

## Monitoring

### Cloud Monitoring Metrics
- **Storage usage**: Monitor bucket size growth
- **Request metrics**: Track access patterns
- **Cost metrics**: Monitor storage and operation costs

### Audit Logs
- All bucket access is logged via Cloud Audit Logs
- Review access patterns and data usage regularly

## Cost Optimization

1. **Lifecycle Rules**: Automatically delete old data to reduce costs
2. **Labels**: Track costs by team, environment, and purpose
3. **Storage Class**: Standard class for frequently accessed analytics data
4. **Monitoring**: Set up billing alerts for unexpected cost increases

## Security Best Practices

1. **Regular Access Review**: Periodically review IAM bindings
2. **Monitor Audit Logs**: Watch for unusual access patterns
3. **Rotate Service Account Keys**: Follow security best practices
4. **Data Classification**: Use labels to classify data sensitivity

## Disaster Recovery

- **Versioning**: Protects against accidental modifications
- **Soft Delete**: 7-day window to recover deleted objects
- **Cross-region Replication**: Consider for critical data (not configured by default)

## Troubleshooting

### Common Issues
1. **Permission Denied**: Configure IAM permissions using commands above
2. **Bucket Already Exists**: Random suffix prevents conflicts
3. **Lifecycle Not Working**: Verify object ages and conditions

### Support
- Review Terraform state: `terraform show`
- Check bucket configuration: `gsutil ls -L -b gs://[BUCKET_NAME]`
- Monitor in Cloud Console: Cloud Storage > Browser

---

**Deployed via**: Terraform Cloud VCS Integration  
**Repository**: `zeeshanvisi/terraform-gcp-infrastructure`  
**Path**: `gcs-buckets/prod-analytics-data/`  
**Auto-Fixed**: 2026-01-21 (Removed problematic IAM group references)
