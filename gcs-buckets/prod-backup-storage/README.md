# Production GCS Backup Storage Bucket

This Terraform configuration creates a production-grade Google Cloud Storage bucket specifically designed for backup storage with enterprise-level security, compliance, and lifecycle management.

## 🚀 Features

### Security & Access Control
- **Public Access Prevention**: Enforced to prevent accidental public exposure
- **Uniform Bucket-Level Access**: Enabled for consistent IAM-based access control
- **Private by Default**: No public access permissions
- **Default Encryption**: Google-managed encryption keys (automatic)

### Data Protection & Versioning
- **Object Versioning**: Enabled to protect against accidental overwrites/deletions
- **Soft Delete Policy**: 7-day retention for accidental deletion recovery
- **Prevent Destroy**: Terraform lifecycle rule prevents accidental infrastructure deletion

### Lifecycle Management
- **90-Day Retention**: Automatic deletion of objects after 90 days as requested
- **Incomplete Upload Cleanup**: Removes failed multipart uploads after 1 day
- **Cost Optimization**: Moves archived versions to NEARLINE storage after 30 days

### Monitoring & Compliance
- **Cost Tracking Labels**: Environment, purpose, team, and cost-center tags
- **Audit Ready**: Configuration supports compliance requirements
- **Production Hardened**: Appropriate settings for production workloads

## 📋 Configuration Details

### Bucket Specifications
- **Name**: `prod-backup-storage`
- **Location**: `us-east5` (configurable)
- **Storage Class**: `STANDARD` (high-performance)
- **Project**: `visionet-merck-poc`

### Lifecycle Policies
1. **Main Retention**: Delete objects after 90 days
2. **Upload Cleanup**: Abort incomplete uploads after 1 day  
3. **Version Management**: Move old versions to NEARLINE after 30 days

### Security Posture
- ✅ Public access blocked
- ✅ Uniform bucket-level access
- ✅ Google-managed encryption
- ✅ IAM-based access control
- ✅ Audit logging ready

## 🛠️ Deployment

This bucket is deployed using GitOps workflow:

1. **GitHub Repository**: `zeeshanvisi/terraform-gcp-infrastructure`
2. **Terraform Cloud Workspace**: `prod-backup-storage-workspace`
3. **Auto-Apply**: Enabled for autonomous deployment
4. **VCS Integration**: Automatic runs on code changes

## 📊 Usage Examples

### Upload a Backup File
```bash
# Using gsutil
gsutil cp /path/to/backup.tar.gz gs://prod-backup-storage/

# Using gcloud
gcloud storage cp /path/to/backup.tar.gz gs://prod-backup-storage/
```

### List Bucket Contents
```bash
# List all objects
gsutil ls gs://prod-backup-storage/

# List with details
gsutil ls -l gs://prod-backup-storage/
```

### Restore from Backup
```bash
# Download a backup
gsutil cp gs://prod-backup-storage/backup.tar.gz /path/to/restore/
```

### Access Previous Versions
```bash
# List all versions of an object
gsutil ls -a gs://prod-backup-storage/backup.tar.gz

# Download a specific version
gsutil cp gs://prod-backup-storage/backup.tar.gz#<generation> /path/to/restore/
```

## 🔐 IAM & Permissions

To access this bucket, users need appropriate IAM roles:

```bash
# Grant storage admin access
gcloud projects add-iam-policy-binding visionet-merck-poc \
    --member="user:user@example.com" \
    --role="roles/storage.admin"

# Grant read-only access
gcloud projects add-iam-policy-binding visionet-merck-poc \
    --member="user:user@example.com" \
    --role="roles/storage.objectViewer"
```

## 🚨 Production Considerations

### Backup Strategy
- This bucket implements the retention policy you requested (90 days)
- Consider implementing cross-region replication for disaster recovery
- Monitor storage costs and adjust lifecycle policies as needed

### Monitoring
- Set up Cloud Monitoring alerts for:
  - Storage usage thresholds
  - Unusual access patterns
  - Failed upload/download attempts

### Cost Optimization
- Objects automatically move to NEARLINE storage for cost savings
- Incomplete uploads are cleaned up automatically
- Consider COLDLINE or ARCHIVE for longer-term retention if needed

## 📈 Next Steps

1. **Set Up IAM**: Grant appropriate access to backup systems
2. **Configure Monitoring**: Set up alerts and dashboards
3. **Test Backup/Restore**: Validate the backup and recovery process
4. **Document Procedures**: Create operational runbooks
5. **Schedule Regular Reviews**: Review lifecycle policies and costs

## 🆘 Support

For issues with this infrastructure:
- Check Terraform Cloud workspace: `prod-backup-storage-workspace`
- Review deployment logs in Terraform Cloud
- Contact the infrastructure team

---

**Deployed via**: GitOps workflow with Terraform Cloud  
**Last Updated**: Auto-managed via VCS integration  
**Environment**: Production  
**Managed By**: GCP Terraform Agent