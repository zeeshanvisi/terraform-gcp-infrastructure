# Production GCS Bucket for Application Logs

This Terraform configuration creates a production-grade Google Cloud Storage bucket specifically designed for application logs with security, compliance, and cost optimization features.

## 🏗️ Architecture Overview

- **Bucket Name**: zee-terra-test-[random-suffix]
- **Location**: US (multi-region for high availability)
- **Storage Class**: STANDARD (with automatic archival)
- **Security**: Private access only, uniform bucket-level access
- **Versioning**: Enabled for data protection
- **Lifecycle**: Automatic archival and cleanup policies

## 🔧 Features

### Security & Compliance
- ✅ **Uniform bucket-level access** - Simplified IAM management
- ✅ **Public access prevention** - Enforced private access
- ✅ **Versioning enabled** - Protection against accidental modifications
- ✅ **Soft delete policy** - 7-day retention for deleted objects
- ✅ **Access logging** - Audit trail for compliance

### Cost Optimization
- ✅ **Automatic archival** - Logs moved to ARCHIVE storage after 90 days
- ✅ **Automatic deletion** - Old logs deleted after 365 days
- ✅ **Version limit** - Maximum 5 versions per object
- ✅ **Cleanup policies** - Incomplete uploads removed after 1 day

### Operational Excellence
- ✅ **Resource labeling** - Cost tracking and organization
- ✅ **Terraform managed** - Infrastructure as code
- ✅ **Random naming** - Globally unique bucket names

## 🚨 Required IAM Permissions

**IMPORTANT**: This Terraform configuration does NOT configure IAM permissions due to service account limitations. You must manually configure the following IAM permissions:

### For Applications to Write Logs
```bash
# Grant Storage Object Creator role to application service accounts
gcloud projects add-iam-policy-binding visionet-merck-poc \
  --member="serviceAccount:your-app-service-account@visionet-merck-poc.iam.gserviceaccount.com" \
  --role="roles/storage.objectCreator"

# If applications need to read their own logs
gcloud projects add-iam-policy-binding visionet-merck-poc \
  --member="serviceAccount:your-app-service-account@visionet-merck-poc.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"
```

### For Log Analysis Teams
```bash
# Grant read-only access to log analysis team
gcloud projects add-iam-policy-binding visionet-merck-poc \
  --member="group:log-analysts@your-domain.com" \
  --role="roles/storage.objectViewer"
```

### For Administrators
```bash
# Grant full access to platform administrators
gcloud projects add-iam-policy-binding visionet-merck-poc \
  --member="group:platform-admins@your-domain.com" \
  --role="roles/storage.admin"
```

## 📊 Usage Examples

### Upload Logs via gcloud CLI
```bash
# Upload a log file
gsutil cp application.log gs://zee-terra-test-[suffix]/app1/2024/01/21/

# Upload with metadata
gsutil -h "x-goog-meta-app:my-app" -h "x-goog-meta-env:production" \
  cp application.log gs://zee-terra-test-[suffix]/app1/2024/01/21/
```

### Access via Application Code (Python)
```python
from google.cloud import storage

client = storage.Client()
bucket = client.bucket('zee-terra-test-[suffix]')

# Upload log file
blob = bucket.blob('app1/2024/01/21/application.log')
blob.upload_from_filename('application.log')

# Add metadata
blob.metadata = {
    'app': 'my-app',
    'environment': 'production',
    'log_level': 'info'
}
blob.patch()
```

## 🏷️ Resource Labels

All resources are tagged with:
- `environment`: production
- `purpose`: application-logs  
- `team`: platform
- `cost-center`: engineering
- `managed-by`: terraform

## 📋 Lifecycle Policies

| Age | Action | Purpose |
|-----|--------|------|
| 1 day | Abort incomplete uploads | Clean up failed uploads |
| 90 days | Move to ARCHIVE | Reduce storage costs |
| 365 days | Delete | Comply with retention policies |
| >5 versions | Delete old versions | Limit version proliferation |

## 🔗 Related Resources

- [GCS Bucket Naming Guidelines](https://cloud.google.com/storage/docs/naming-buckets)
- [Storage Classes](https://cloud.google.com/storage/docs/storage-classes)
- [Lifecycle Management](https://cloud.google.com/storage/docs/lifecycle)
- [IAM for Storage](https://cloud.google.com/storage/docs/access-control/iam)

## 📞 Support

For questions about this infrastructure:
- **Platform Team**: platform@your-domain.com
- **Documentation**: [Internal Wiki Link]
- **Terraform Cloud**: https://app.terraform.io/app/Visionetpvt/workspaces/zee-terra-test-logs-workspace

---
*This infrastructure is managed via GitOps. All changes should be made through pull requests to the terraform-gcp-infrastructure repository.*