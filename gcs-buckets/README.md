# GCS Buckets Infrastructure

This directory contains Terraform configurations for Google Cloud Storage bucket deployments.

## Structure

Place individual bucket configurations in subdirectories following the pattern:
- `gcs-buckets/<bucket-name>/` - Contains main.tf, variables.tf, outputs.tf, and README.md

## Usage

Each subdirectory should be configured as a separate Terraform Cloud workspace with the working directory set to the specific bucket path.