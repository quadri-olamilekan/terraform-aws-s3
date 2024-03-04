# Terraform Module - AWS S3 bucket

## Overview

This Terraform configuration is designed to create a comprehensive AWS infrastructure to support secure and scalable handling of S3 events, including replication and encryption. Below is a detailed overview of the resources provisioned by this configuration.

## Usage

```hcl
module "s3-bucket" {
  source  = "quadri-olamilekan/s3-bucket/aws"
  version = "1.0.1"
  # insert the required variables here
}
```

## Resources Created

## 1. IAM Role for Replication and KMS key

- iam role for replication
- iam policy for replication
- iam role policy attachment for replication
- kms key policy

## 2. KMS Keys
- KMS Key for Source Bucket
- KMS Key for Destination Bucket

## 3. S3 Buckets
- Source Bucket
- Destination/backend Bucket
- Log Buckets for Source and Destination

## 4. S3 Bucket Policies
- Replication Configuration
- Server-side Encryption Configuration
- Bucket Versioning
- Bucket Lifecycle Configuration

## 5. S3 Bucket Logging
- Destination/Backend Bucket Logging
- Source Bucket Logging

## 6. S3 Bucket Notification
- Destination/Backend Bucket Notification
- Source Bucket Notification

## 7. S3 Bucket Public Access Block
- Destination/Backend Public Access Block
- Source Bucket Public Access Block

## 8. SQS Queues
- Destination/Backend Queue
- Source Queue

## Outputs

- Destination Bucket URL
- Source Bucket URL
- Destinantion SQS Queue URL
- Source SQS Queue URL


## Notes

- Please ensure that you have the necessary AWS credentials and permissions before applying this module.

- Feel free to customize the module based on your specific requirements.

- For any issues or questions, contact the module maintainer at olamilekanbello1023@gmail.com  or via phone at +13065021578.

## License

This Terraform module is licensed under the MIT License. 
