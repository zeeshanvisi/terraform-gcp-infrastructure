# Production GCS Backup Bucket

## Overview

This Terraform configuration creates a production-grade Google Cloud Storage bucket for critical backup data with enterprise-level security and data lifecycle management.

## Features

### 🔐 Security
- **Uniform bucket-level access** enforced
- **Public access prevention** enabled
- **Private by default** configuration
- **Soft delete policy** (7-day retention)

### 📦 Data Management
- **Object versioning** enabled for data protection
- **Lifecycle policy** automatically deletes objects after 365 days
- **Archived version cleanup** after 30 days
- **Multi-region storage** for high availability

### 📊 Monitoring
- **Cost allocation labels** for tracking
- **Ready for monitoring integration** (Pub/Sub notifications can be added manually)

## Architecture

```
┌─────────────────────────────────────────┐
│            GCS Bucket                   │
│   company-backups-{random-suffix}      │
│                                         │
│  Features:                              │
│  • Multi-region (US)                    │
│  • Versioning enabled                   │
│  • 365-day lifecycle                    │
│  • Uniform bucket access                │
│  • Public access blocked                │
│  • Soft delete protection              │
└─────────────────────────────────────────┘
```

## Deployment

This infrastructure is automatically deployed via:
1. **Terraform Cloud** workspace: `company-backups-prod-workspace`
2. **GitHub repository**: `zeeshanvisi/terraform-gcp-infrastructure`
3. **VCS integration** triggers on code changes
4. **Auto-apply** enabled for continuous deployment

## Usage

### Upload Backup Files
```bash
# Single file
gsutil cp /path/to/backup-file gs://company-backups-{suffix}/

# Directory with subdirectories
gsutil -m cp -r /path/to/backup-directory gs://company-backups-{suffix}/

# With parallel uploads for large files
gsutil -o GSUtil:parallel_composite_upload_threshold=150M cp large-backup.tar.gz gs://company-backups-{suffix}/
```

### Restore Data
```bash
# Download specific file
gsutil cp gs://company-backups-{suffix}/backup-file /local/restore/path/

# Download specific version
gsutil cp gs://company-backups-{suffix}/backup-file#1234567890 /local/restore/path/

# Restore entire directory
gsutil -m cp -r gs://company-backups-{suffix}/backup-directory /local/restore/path/
```

### Version Management
```bash
# List all versions of a file
gsutil ls -a gs://company-backups-{suffix}/backup-file

# List all objects with versions
gsutil ls -la gs://company-backups-{suffix}/

# Restore specific version
gsutil cp gs://company-backups-{suffix}/backup-file#1234567890 gs://company-backups-{suffix}/backup-file
```

### Monitoring
```bash
# Check bucket information
gsutil ls -L -b gs://company-backups-{suffix}/
```

## Required IAM Permissions

**⚠️ IMPORTANT**: The Terraform service account used for deployment does not have IAM management permissions. You must manually configure the following IAM permissions:

### For Backup Operations
```bash
# Grant storage admin to backup service accounts
gcloud projects add-iam-policy-binding visionet-merck-poc \
    --member="serviceAccount:backup-service@visionet-merck-poc.iam.gserviceaccount.com" \
    --role="roles/storage.objectAdmin"

# Grant read access to restore operators
gcloud projects add-iam-policy-binding visionet-merck-poc \
    --member="group:backup-operators@company.com" \
    --role="roles/storage.objectViewer"
```

### For Monitoring (Optional)
```bash
# If you want to add Pub/Sub notifications manually:
# 1. Create a Pub/Sub topic
gcloud pubsub topics create company-backups-notifications

# 2. Grant Cloud Storage service account publisher access
gsutil notification create -t company-backups-notifications -f json gs://company-backups-{suffix}
```

## Lifecycle Policy Details

| Condition | Action | Purpose |
|-----------|--------|---------|
| Age > 365 days | Delete | Automatic cleanup of old backups |
| Archived version age > 30 days | Delete | Clean up old file versions |
| Soft delete | 7-day retention | Protection against accidental deletion |

## Cost Optimization

- **Multi-region storage**: Higher availability but higher cost than regional
- **Lifecycle policies**: Automatic cleanup reduces storage costs
- **Labels**: Enable cost tracking by environment, purpose, and cost center
- **Consider**: Moving to Coldline/Archive storage for long-term retention

## Security Best Practices

✅ **Implemented**:
- Uniform bucket-level access
- Public access prevention
- Versioning for data protection
- Soft delete policy
- Cost allocation labels

⚠️ **Manual Configuration Required**:
- IAM permissions for users/service accounts
- Monitoring notifications (Pub/Sub)
- VPC Service Controls (if needed)
- Customer-managed encryption keys (if required)
- Access logging configuration

## Auto-Fix Applied

**🔧 Issue Resolved**: Initial deployment failed due to IAM permission errors. The following changes were automatically applied:

1. **Removed**: Pub/Sub topic and notifications (requires IAM management)
2. **Removed**: IAM bindings for Cloud Storage service account
3. **Removed**: Data sources requiring IAM permissions
4. **Kept**: All core bucket functionality (versioning, lifecycle, security)

**📋 Next Steps**: You can manually add monitoring notifications later by following the instructions above.

## Troubleshooting

### Common Issues

**Upload failures:**
```bash
# Check permissions
gsutil iam get gs://company-backups-{suffix}

# Verify authentication
gcloud auth list
```

**Lifecycle policy not working:**
```bash
# Check bucket lifecycle configuration
gsutil lifecycle get gs://company-backups-{suffix}
```

## Support

For infrastructure changes:
1. Update Terraform code in this directory
2. Commit to GitHub main branch
3. Terraform Cloud will automatically apply changes

For access issues or IAM configuration:
1. Contact your GCP administrator
2. Reference the IAM permissions section above

---

**Deployed by**: GCP Terraform Agent (Auto-Fixed)  
**Workspace**: company-backups-prod-workspace  
**Last Updated**: $(date)  
**Version**: 1.1.0 (Auto-Fix Applied)