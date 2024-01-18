# Terraform Module - AWS S3 bucket

## Overview

This Terraform configuration is designed to create a comprehensive AWS infrastructure to support secure and scalable handling of S3 events, including replication and encryption. Below is a detailed overview of the resources provisioned by this configuration.

## Security & Compliance [<img src="https://cloudposse.com/wp-content/uploads/2020/11/bridgecrew.svg" width="250" align="right" />](https://bridgecrew.io/)

Security scanning is graciously provided by Bridgecrew. Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

| Benchmark | Description |
|--------|---------------|
| [![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=INFRASTRUCTURE+SECURITY) | Infrastructure Security Compliance |
| [![CIS KUBERNETES](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/cis_kubernetes_16)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=CIS+KUBERNETES+V1.6)| Center for Internet Security, KUBERNETES Compliance |
| [![CIS AWS](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=CIS+AWS+V1.2) | Center for Internet Security, AWS Compliance |
| [![CIS AZURE](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/cis_azure)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=CIS+AZURE+V1.1) | Center for Internet Security, AZURE Compliance |
| [![PCI-DSS](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/pci_dss_v321)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=PCI-DSS+V3.2.1) | Payment Card Industry Data Security Standards Compliance |
| [![NIST-800-53](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=NIST-800-53) | National Institute of Standards and Technology Compliance |
| [![ISO27001](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=ISO27001) | Information Security Management System, ISO/IEC 27001 Compliance |
| [![SOC2](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=SOC2)| Service Organization Control 2 Compliance |
| [![CIS GCP](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/cis_gcp)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=CIS+GCP+V1.1) | Center for Internet Security, GCP Compliance |
| [![HIPAA](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=HIPAA) | Health Insurance Portability and Accountability Compliance |
| [![CIS EKS](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/cis_eks_11)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=CIS+EKS+V1.1) | Center for Internet Security, EKS Compliance |
| [![CIS DOCKER](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/cis_docker_12)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=CIS+DOCKER+V1.2) | Center for Internet Security, DOCKER Compliance |
| [![CIS GKE](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/cis_gke_11)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=CIS+GKE+V1.1) | Center for Internet Security, GKE Compliance |
| [![FEDRAMP (MODERATE)](https://www.bridgecrew.cloud/badges/github/quadri-olamilekan/terraform-aws-s3-bucket/fedramp_moderate)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=quadri-olamilekan%2Fterraform-aws-s3-bucket&benchmark=FEDRAMP+%28MODERATE%29) | FEDRAMP (MODERATE) |

## Usage

```hcl
module "s3-bucket" {
  source  = "quadri-olamilekan/s3-bucket/aws"
  version = "1.0.0"
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
