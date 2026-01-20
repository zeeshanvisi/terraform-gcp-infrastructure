# Development GCS Bucket: zee-test

This Terraform configuration creates a development GCS bucket with versioning, lifecycle management, and security best practices.

## 🚀 Deployment Status

**Deployed via:** Terraform Cloud VCS Integration  
**Repository:** `terraform-gcp-infrastructure`  
**Path:** `gcs-buckets/zee-test/`  
**Environment:** Development  
**Workspace:** `dev-gcs-bucket-zee-test`  

## 📦 Resources Created

- **GCS Bucket**: `visionet-merck-poc-dev-zee-test`
- **IAM Binding**: Service account admin access
- **Sample Object**: README.txt (for testing)

## 🔧 Configuration Features

### Security
- ✅ **Public access prevention**: Enforced
- ✅ **Uniform bucket-level access**: Enabled
- ✅ **Encryption**: Google-managed encryption (default)
- ✅ **IAM**: Least-privilege access

### Versioning & Lifecycle
- ✅ **Versioning**: Enabled for data protection
- ✅ **Lifecycle rules**:
  - Objects move to Nearline after 30 days
  - Objects deleted after 90 days
- ✅ **Force destroy**: Enabled for dev environment

### Cost Optimization
- 🏷️ **Resource labels**: For cost tracking and management
- 📊 **Lifecycle policies**: Automatic storage class transitions
- 🗑️ **Automatic deletion**: Prevents storage cost accumulation

## 📋 Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `project_id` | `visionet-merck-poc` | GCP project ID |
| `region` | `us-east5` | GCP region |
| `environment` | `dev` | Environment name |
| `bucket_name` | `zee-test` | Base bucket name |
| `versioning_enabled` | `true` | Enable versioning |
| `lifecycle_delete_age` | `90` | Days before deletion |
| `lifecycle_nearline_age` | `30` | Days before Nearline transition |
| `create_sample_object` | `true` | Create test README object |

## 🎯 Outputs

- `bucket_name`: Full bucket name
- `bucket_url`: gs:// URL
- `bucket_self_link`: REST API link
- `bucket_location`: Geographic location
- `versioning_enabled`: Versioning status
- `bucket_labels`: Applied labels

## 🚀 Usage Examples

### Upload a file
```bash
# Using gsutil
gsutil cp myfile.txt gs://visionet-merck-poc-dev-zee-test/

# Using gcloud
gcloud storage cp myfile.txt gs://visionet-merck-poc-dev-zee-test/
```

### List bucket contents
```bash
gsutil ls gs://visionet-merck-poc-dev-zee-test/
```

### Enable notifications (optional)
```bash
gsutil notification create -t my-topic gs://visionet-merck-poc-dev-zee-test/
```

## 🔄 GitOps Workflow

1. **Code changes** pushed to `gcs-buckets/zee-test/`
2. **Terraform Cloud VCS** automatically detects changes
3. **Plan phase** shows proposed changes
4. **Apply phase** deploys infrastructure
5. **State management** handled by Terraform Cloud

## 🛠️ Manual Operations

### Update bucket configuration
1. Modify `.tf` files in this directory
2. Commit and push to `main` branch
3. Terraform Cloud will automatically plan and apply

### Destroy resources (dev only)
```bash
# Via Terraform Cloud UI or API
# Note: force_destroy = true allows deletion of non-empty buckets
```

## 📊 Monitoring & Logging

- **Cloud Logging**: Bucket access logs automatically enabled
- **Cloud Monitoring**: Standard GCS metrics available
- **Labels**: Use for cost allocation and resource grouping

## ⚠️ Important Notes

- **Development Environment**: `force_destroy = true` allows Terraform to delete non-empty buckets
- **Lifecycle Management**: Objects are automatically managed to optimize costs
- **Security**: Public access is prevented by default
- **Versioning**: Protects against accidental deletion/modification

## 🆘 Troubleshooting

### Common Issues

**Bucket name already exists**
- Bucket names are globally unique
- Modify `bucket_name` variable if needed

**Permission denied**
- Ensure service account has proper IAM roles
- Check organization policies

**Lifecycle conflicts**
- Adjust lifecycle ages if objects are being moved too quickly

### Getting Help

1. Check Terraform Cloud run logs
2. Review GCP Console for bucket status
3. Verify IAM permissions
4. Check organization policies

---

**Last Updated**: Generated via GCP Terraform Agent  
**Terraform Version**: >= 1.0  
**Google Provider**: ~> 6.0  