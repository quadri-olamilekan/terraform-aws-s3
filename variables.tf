variable "backend_region" {
  type        = string
  description = "The region for the destination of the s3 bucket replication"
}

variable "source_region" {
  type        = string
  description = "The region for the source bucket"
}

variable "env" {
  type        = string
  description = "keeper for working environment"
}

variable "create_vpc" {
  type        = bool
  default     = true
  description = "Set to true if you want to create an S3 bucket, false otherwise."
}

variable "min_int" {
  type        = number
  default     = 1
  description = "minimum integer for random number generation"
}

variable "max_int" {
  type        = number
  default     = 100
  description = "maximum integer for random number generation"
}

variable "aws_iam_role_name" {
  type        = string
  default     = "tf-iam-role-replication-12345"
  description = " Friendly name of the iam role for the replication."
}

variable "aws_iam_role_policy_attachment_name" {
  type        = string
  default     = "tf-iam-role-policy-replication-12345"
  description = "Friendly name of the iam role policy attachment for the replication."
}

variable "tag_backend" {
  type        = map(string)
  default     = { Name = "backend" }
  description = "Tags for the destination bucket"
}

variable "tag_source" {
  type        = map(string)
  default     = { Name = "source" }
  description = "Tags for the source bucket"
}

variable "versioning" {
  type        = string
  default     = "Enabled"
  description = "(Required) Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."
}

variable "rep_rule_id" {
  type        = string
  default     = "foobar"
  description = " Unique identifier for the rule for Replication. Must be less than or equal to 255 characters in length."
}

variable "rule_filter" {
  type        = string
  default     = "foo"
  description = "Filter that identifies subset of objects to which the replication rule applies."
}

variable "rep_rule_status" {
  type        = string
  default     = "Enabled"
  description = " Status of the rule for Replication. Either Enabled or Disabled The rule is ignored if status is not Enabled"
}

variable "replica_modifications_status" {
  type        = string
  default     = "Enabled"
  description = " Whether the existing objects should be replicated. Either Enabled or Disabled"
}

variable "sse_kms_encrypted_objects_status" {
  type        = string
  default     = "Enabled"
  description = "Whether the existing objects should be replicated. Either Enabled or Disabled"
}

variable "replication_time_status" {
  type        = string
  default     = "Enabled"
  description = " Status of the Replication Time Control. Either Enabled or Disabled"

}

variable "replication_time" {
  type        = number
  default     = 15
  description = "Configuration block specifying the time by which replication should be complete for all objects and operations on objects."
}

variable "dest_storage_class" {
  type        = string
  default     = "STANDARD"
  description = "The storage class used to store the object. By default, Amazon S3 uses the storage class of the source object to create the object replica."
}

variable "metrics_status" {
  type        = string
  default     = "Enabled"
  description = " Status of the Destination Metrics. Either Enabled or Disabled"
}

variable "metrics_time" {
  type        = number
  default     = 15
  description = " Time in minutes. Valid values: 15"
}

variable "delete_marker_replication_status" {
  type        = string
  default     = "Enabled"
  description = "status -  Whether delete markers should be replicated. Either Enabled or Disabled"
}

variable "lc_rule_id_b" {
  type        = string
  default     = "backend-rule"
  description = " Unique identifier for the rule for destination bucket lifecycle configuration. Must be less than or equal to 255 characters in length."
}

variable "lc_rule_status_b" {
  type        = string
  default     = "Enabled"
  description = " Status of the rule for destination bucket lifecycle configuration. Either Enabled or Disabled The rule is ignored if status is not Enabled"
}

variable "tran_sc_b" {
  type        = string
  default     = "STANDARD_IA"
  description = "Class of storage used to store the object. Valid Values: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR"
}

variable "tran_days_b" {
  type        = number
  default     = 30
  description = "Number of days after creation when objects are transitioned to the specified storage class. The value must be a positive integer."

}

variable "exp_days_b" {
  type        = number
  default     = 365
  description = " Lifetime, in days, of the objects that are subject to the rule. The value must be a non-zero positive integer."

}

variable "lc_rule_id_s" {
  type        = string
  default     = "source-rule"
  description = " Unique identifier for the rule for destination bucket lifecycle configuration. Must be less than or equal to 255 characters in length."
}

variable "lc_rule_status_s" {
  type        = string
  default     = "Enabled"
  description = "Status of the rule for destination bucket lifecycle configuration. Either Enabled or Disabled The rule is ignored if status is not Enabled"
}

variable "tran_sc_s" {
  type        = string
  default     = "STANDARD_IA"
  description = "Class of storage used to store the object. Valid Values: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR"
}

variable "tran_days_s" {
  type        = number
  default     = 30
  description = "Number of days after creation when objects are transitioned to the specified storage class. The value must be a positive integer."

}

variable "exp_days_s" {
  type        = number
  default     = 365
  description = " Lifetime, in days, of the objects that are subject to the rule. The value must be a non-zero positive integer."
}

variable "block_public_acls_b" {
  type        = bool
  default     = true
  description = " Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs."
}

variable "block_public_policy_b" {
  type        = bool
  default     = true
  description = " Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy."

}

variable "ignore_public_acls_b" {
  type        = bool
  default     = true
  description = " Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set"
}

variable "restrict_public_buckets_b" {
  type        = bool
  default     = true
  description = " Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked."
}

variable "block_public_acls_s" {
  type        = bool
  default     = true
  description = " Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs."
}

variable "block_public_policy_s" {
  type        = bool
  default     = true
  description = " Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy."

}

variable "ignore_public_acls_s" {
  type        = bool
  default     = true
  description = " Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set"
}

variable "restrict_public_buckets_s" {
  type        = bool
  default     = true
  description = " Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked."
}

variable "target_prefix_b" {
  type        = string
  default     = "log/"
  description = "Prefix for all log object keys"
}

variable "target_prefix_s" {
  type        = string
  default     = "log/"
  description = "Prefix for all log object keys"
}

variable "dwd_b" {
  type        = number
  default     = 10
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30"
}

variable "dwd_s" {
  type        = number
  default     = 10
  description = " The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30"
}

variable "ekr_b" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled."
}

variable "ekr_s" {
  type        = bool
  default     = true
  description = " Specifies whether key rotation is enabled."
}

variable "sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = " Server-side encryption algorithm to use. Valid values are AES256, aws:kms, and aws:kms:dsse"
}

variable "sqs_b" {
  type        = string
  default     = "s3-event-notification-queue"
  description = "The name of the queue. Queue names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long. For a FIFO (first-in-first-out) queue, the name must end with the .fifo suffix. If omitted, Terraform will assign a random, unique name."
}

variable "sqs_s" {
  type        = string
  default     = "s3-event-notification-queue"
  description = " The name of the queue. Queue names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long. For a FIFO (first-in-first-out) queue, the name must end with the .fifo suffix. If omitted, Terraform will assign a random, unique name."
}

variable "event_b" {
  type = list(string)
  default = ["s3:ObjectCreated:*",
    "s3:LifecycleTransition",
    "s3:LifecycleExpiration:*",
    "s3:ObjectRemoved:*",
    "s3:ObjectRestore:*",
  "s3:Replication:*"]
  description = " Specifies event for which to send notifications"
}

variable "event_s" {
  type = list(string)
  default = ["s3:ObjectCreated:*",
    "s3:LifecycleTransition",
    "s3:LifecycleExpiration:*",
    "s3:ObjectRemoved:*",
    "s3:ObjectRestore:*",
  "s3:Replication:*"]
  description = "(Required) Specifies event for which to send notifications"
}

variable "not_suffix_b" {
  type        = string
  default     = ".log"
  description = "(Optional) Object key name suffix."
}

variable "not_suffix_s" {
  type        = string
  default     = ".log"
  description = "(Optional) Object key name suffix."
}