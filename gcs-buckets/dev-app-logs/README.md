# Development GCS Bucket for Application Logs

This Terraform configuration creates a Google Cloud Storage (GCS) bucket specifically designed for storing application logs in a development environment.

## Features

### 🔒 Security
- **Uniform bucket-level access** enabled for simplified IAM management
- **Public access prevention** enforced to prevent accidental exposure
- **Encryption at rest** using Google-managed encryption keys (default)
- **Private bucket** with no public access

### 📁 Versioning
- **Object versioning enabled** to recover accidentally overwritten or deleted log files
- **Soft delete policy** with 7-day retention for additional recovery options

### 💰 Cost Optimization
- **Intelligent lifecycle management**:
  - Standard storage for active logs (0-30 days)
  - Nearline storage for recent logs (30-90 days)
  - Coldline storage for archived logs (90-365 days)
  - Automatic deletion after 1 year (appropriate for dev environment)
- **Multipart upload cleanup** after 7 days to prevent storage waste

### 🏷️ Organization
- **Comprehensive labeling** for cost tracking and resource management
- **Random suffix** ensures globally unique bucket names

## Resources Created

1. **google_storage_bucket.dev_app_logs** - Main GCS bucket for log storage
2. **random_id.bucket_suffix** - Generates unique suffix for bucket naming

## Configuration

### Default Settings
- **Project**: visionet-merck-poc
- **Region**: us-east5
- **Storage Class**: STANDARD
- **Retention**: 365 days (1 year)
- **Environment**: dev

### Customizable Variables
- `project_id` - GCP project ID (default: visionet-merck-poc)
- `region` - GCP region (default: us-east5)
- `retention_days` - Log retention period (default: 365 days)
- `environment` - Environment name (default: dev)

## Usage Examples

### Upload Application Logs
```bash
# Upload a log file
gsutil cp application.log gs://$(terraform output -raw bucket_name)/app-logs/$(date +%Y/%m/%d)/

# Upload with metadata
gsutil -h "x-goog-meta-application:my-app" \
       -h "x-goog-meta-version:1.0.0" \
       cp application.log gs://$(terraform output -raw bucket_name)/
```

### Access Logs Programmatically
```python
from google.cloud import storage

client = storage.Client()
bucket_name = "YOUR_BUCKET_NAME"  # From terraform output
bucket = client.bucket(bucket_name)

# List recent logs
blobs = bucket.list_blobs(prefix="app-logs/")
for blob in blobs:
    print(f"Log: {blob.name}, Size: {blob.size}, Created: {blob.time_created}")
```

## Lifecycle Management

| Age | Storage Class | Cost | Use Case |
|-----|---------------|------|----------|
| 0-30 days | Standard | Higher | Active debugging, recent logs |
| 30-90 days | Nearline | Medium | Occasional access, troubleshooting |
| 90-365 days | Coldline | Lower | Archived logs, compliance |
| 365+ days | Deleted | None | Automatic cleanup for dev |

## Security Best Practices

✅ **What's Implemented**:
- Uniform bucket-level access
- Public access prevention
- Encryption at rest (Google-managed)
- Private bucket configuration

⚠️ **Additional Recommendations**:
- Use IAM roles instead of legacy ACLs
- Implement least-privilege access
- Enable audit logging for bucket access
- Consider customer-managed encryption keys for sensitive data

## Monitoring and Alerting

Consider setting up:
- **Cloud Monitoring** alerts for bucket size and costs
- **Cloud Logging** for bucket access patterns
- **Budget alerts** for unexpected storage costs
- **Lifecycle transition monitoring** for cost optimization

## Cost Estimation

For typical dev workloads:
- **10GB/month new logs**: ~$0.20/month (Standard)
- **100GB stored (mixed classes)**: ~$1.50/month
- **1,000 API calls/month**: ~$0.004/month

*Costs vary by region and actual usage patterns*

## Disaster Recovery

- **Versioning**: Recover from accidental overwrites
- **Soft delete**: 7-day recovery window for deleted objects
- **Cross-region replication**: Not enabled (consider for production)
- **Backup strategy**: Consider additional backup for critical logs

## Support

For issues or questions:
1. Check Terraform Cloud run logs
2. Review GCP Cloud Storage documentation
3. Contact the DevOps team

---

**Deployment Information**:
- Deployed via Terraform Cloud
- Managed by: GCP Terraform Agent
- Environment: Development
- Last Updated: $(date)
