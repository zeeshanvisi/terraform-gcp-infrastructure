# Terraform Test GCS Bucket

This Terraform configuration creates a development GCS bucket named `terraform-test` for storing application logs.

## Features

- **Versioning**: Enabled to protect against accidental deletion/modification
- **Encryption**: Uses Google-managed encryption keys (default)
- **Access Control**: Uniform bucket-level access with IAM bindings
- **Security**: Public access prevention enforced
- **Lifecycle Management**: Automatic cleanup after 30 days for cost optimization
- **Soft Delete**: 7-day retention for accidentally deleted objects
- **Monitoring**: Comprehensive labeling for cost tracking and resource management

## Configuration Details

- **Storage Class**: STANDARD (for frequent access)
- **Location**: us-east5
- **Environment**: Development
- **Force Destroy**: Enabled (for easy cleanup in dev environment)

## IAM Permissions

- **Object Creator**: Application service account can write logs
- **Object Viewer**: Application service account can read logs

## Lifecycle Policies

1. **Auto-delete**: Objects older than 30 days are automatically deleted
2. **Multipart Upload Cleanup**: Incomplete uploads are aborted after 1 day

## Usage

After deployment, applications can write logs to:
```
gs://terraform-test/
```

## Cost Optimization

- Objects are automatically deleted after 30 days
- Uniform bucket-level access reduces IAM complexity
- STANDARD storage class for development workloads

## Security Features

- Public access prevention enforced
- Uniform bucket-level access enabled
- IAM-based access control
- Google-managed encryption

## Monitoring & Labels

The bucket includes comprehensive labels for:
- Cost tracking by environment and purpose
- Resource management
- Automated governance policies

## Next Steps

1. Update application configurations to use the bucket URL
2. Configure log rotation in applications
3. Set up monitoring alerts for bucket usage
4. Review and adjust lifecycle policies as needed
