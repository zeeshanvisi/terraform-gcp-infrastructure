# Auto Apply Test GCS Bucket

This is a minimal GCS bucket created to test the auto-apply functionality in Terraform Cloud.

## Configuration

- **Bucket Name**: auto-apply-test-final
- **Location**: us-east5
- **Environment**: dev
- **Force Destroy**: Enabled for easy cleanup
- **Public Access**: Prevented
- **Versioning**: Enabled

## Features

- Minimal configuration for testing
- Basic security with public access prevention
- Versioning enabled
- Proper labeling for resource management
- Force destroy enabled for dev environment cleanup

## Deployment

This infrastructure is deployed via GitOps workflow:
1. Code pushed to GitHub
2. Terraform Cloud VCS integration triggers automatically
3. Auto-apply executes the plan without manual approval

## Testing Auto-Apply

This workspace is specifically configured to test the auto-apply functionality where changes are automatically applied without manual intervention.
