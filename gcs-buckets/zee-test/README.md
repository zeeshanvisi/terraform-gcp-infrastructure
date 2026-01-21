# GCS Bucket: zee-test (Development Environment)

This Terraform configuration creates a Google Cloud Storage bucket for development application logs with the following features:

## Features

### Security & Access
- **Encryption**: Google-managed encryption enabled by default
- **Public Access Prevention**: Enforced to prevent accidental public exposure
- **Uniform Bucket-Level Access**: Simplified IAM management
- **IAM Bindings**: 
  - Service accounts can write logs (`storage.objectCreator`)
  - Development team can read logs (`storage.objectViewer`)

### Data Management
- **Versioning**: Enabled for log file history and recovery
- **Lifecycle Rules**:
  - Move to Nearline storage after 7 days (cost optimization)
  - Delete logs after 30 days (dev environment cleanup)
  - Clean up incomplete uploads after 1 day
- **Soft Delete**: 7-day retention for accidental deletion protection

### Operational
- **Labels**: Environment, purpose, team, and management tracking
- **Force Destroy**: Enabled for dev environment (safe cleanup)
- **Storage Class**: Standard for frequently accessed logs

## Usage

### Deploying
This bucket is automatically deployed via Terraform Cloud when code is pushed to the `gcs-buckets/zee-test/` directory.

### Accessing Logs
```bash
# List objects in the bucket
gsutil ls gs://zee-test/

# Download a specific log file
gsutil cp gs://zee-test/app-logs/2024/01/20/app.log ./

# Upload logs to the bucket
gsutil cp ./application.log gs://zee-test/logs/$(date +%Y/%m/%d)/
```

### Monitoring
- Monitor storage usage in GCP Console
- Set up alerts for unusual upload/access patterns
- Review lifecycle rule effectiveness monthly

## Configuration

### Key Variables
- `project_id`: visionet-merck-poc
- `region`: us-east5
- `environment`: dev

### Customization
To modify bucket behavior:
1. Update variables in `variables.tf`
2. Modify lifecycle rules in `main.tf`
3. Adjust IAM bindings as needed
4. Commit changes to trigger deployment

## Security Notes

⚠️ **Development Environment**
- Force destroy is enabled for easy cleanup
- 30-day log retention (shorter than production)
- Relaxed access controls for development team

🔒 **Security Features**
- No public access allowed
- Encrypted at rest (Google-managed keys)
- Audit logging enabled by default
- Uniform bucket-level access

## Terraform Resources Created

1. `google_storage_bucket.zee_test_logs` - Main GCS bucket
2. `google_storage_bucket_iam_binding.log_writers` - Write access for service accounts
3. `google_storage_bucket_iam_binding.log_readers` - Read access for dev team

## Links

- [Terraform Cloud Workspace](https://app.terraform.io/app/Visionetpvt/workspaces/zee-test-gcs-dev)
- [GCP Console](https://console.cloud.google.com/storage/browser/zee-test?project=visionet-merck-poc)
- [GitHub Repository](https://github.com/zeeshanvisi/terraform-gcp-infrastructure/tree/main/gcs-buckets/zee-test)

## Support

For issues or modifications, contact the infrastructure team or create an issue in the GitHub repository.