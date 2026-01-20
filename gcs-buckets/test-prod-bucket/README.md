# Production GCS Bucket: test-prod-bucket

This Terraform configuration deploys a production-grade Google Cloud Storage bucket with comprehensive security, compliance, and operational features.

## 🏗️ Infrastructure Overview

### Resources Created
- **Primary GCS Bucket**: Production storage with 90-day retention
- **Audit Logs Bucket**: Separate bucket for access and operation logs
- **Pub/Sub Topic**: Real-time notifications for bucket events
- **IAM Policies**: Least-privilege access control
- **Lifecycle Policies**: Automated data management

### Key Features
- ✅ **Security**: Uniform bucket-level access, public access prevention
- ✅ **Versioning**: Object versioning enabled for data protection
- ✅ **Retention**: 90-day automatic deletion policy
- ✅ **Audit Logging**: Comprehensive access and operation logging
- ✅ **Notifications**: Real-time event notifications via Pub/Sub
- ✅ **Cost Optimization**: Appropriate storage classes and lifecycle management
- ✅ **Compliance**: 7-year audit log retention

## 📋 Configuration Details

### Bucket Configuration
- **Name**: `test-prod-bucket-<timestamp>`
- **Location**: `us-central1`
- **Storage Class**: `STANDARD`
- **Retention**: 90 days
- **Versioning**: Enabled
- **Public Access**: Prevented

### Security Features
- Uniform bucket-level access (IAM only, no ACLs)
- Public access prevention enforced
- Separate audit logging bucket
- Least-privilege IAM bindings
- Event-based monitoring

### Lifecycle Management
1. **Current Objects**: Deleted after 90 days
2. **Non-current Versions**: Deleted after 30 days
3. **Audit Logs**: Retained for 7 years (compliance)

## 🚀 Deployment

This infrastructure is deployed using Terraform Cloud with VCS integration:

1. **Code Push**: Terraform files committed to GitHub
2. **Auto-Trigger**: VCS webhook triggers Terraform Cloud run
3. **Auto-Apply**: Approved changes applied automatically
4. **State Management**: Remote state stored in Terraform Cloud

## 📊 Monitoring & Alerting

### Pub/Sub Notifications
The bucket publishes events to `test-prod-bucket-<timestamp>-notifications` topic:
- `OBJECT_FINALIZE`: When objects are uploaded
- `OBJECT_DELETE`: When objects are deleted

### Audit Logging
All bucket operations logged to separate audit bucket:
- Access logs
- Data access logs
- Admin activity logs
- 7-year retention for compliance

## 💰 Cost Optimization

- **Primary Bucket**: STANDARD storage class for frequently accessed data
- **Audit Logs**: NEARLINE storage class for cost-effective log storage
- **Lifecycle Policies**: Automatic cleanup prevents storage bloat
- **Labels**: Comprehensive labeling for cost tracking and allocation

## 🔧 Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `project_id` | `visionet-merck-poc` | GCP project ID |
| `region` | `us-central1` | GCP region for resources |
| `bucket_name_prefix` | `test-prod-bucket` | Bucket name prefix |
| `retention_days` | `90` | Object retention period |
| `environment` | `production` | Environment label |

## 📤 Outputs

- `bucket_name`: Generated bucket name with timestamp
- `bucket_url`: Direct bucket URL
- `bucket_self_link`: API self-link
- `audit_logs_bucket_name`: Audit logs bucket name
- `notification_topic`: Pub/Sub topic for events
- Security and retention policy details

## 🛡️ Security Best Practices

1. **Access Control**: IAM-only access (no ACLs)
2. **Public Access**: Completely prevented
3. **Versioning**: Enabled for data protection
4. **Audit Trail**: Comprehensive logging
5. **Least Privilege**: Minimal required permissions
6. **Encryption**: Google-managed encryption (default)

## 📞 Support

For infrastructure issues or questions:
- **Terraform Cloud**: [Workspace](https://app.terraform.io/app/Visionetpvt/workspaces/prod-gcs-bucket-test)
- **GitHub Repository**: [terraform-gcp-infrastructure](https://github.com/zeeshanvisi/terraform-gcp-infrastructure)
- **Documentation**: This README and inline Terraform comments

---

**Deployed via**: GCP Terraform Agent (GitOps)  
**Last Updated**: Auto-generated timestamp  
**Terraform Version**: >= 1.0  
**Google Provider**: ~> 6.0