provider "aws" {
  region = var.backend_region
}

provider "aws" {
  alias  = "source"
  region = var.source_region
}

resource "aws_iam_role" "replication" {
  provider           = aws.source
  name               = "tf-iam-role-replication-12345"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "replication" {
  provider = aws.source
  name     = "tf-iam-role-policy-replication-12345"
  policy   = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  provider   = aws.source
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

#1. S3 bucket
resource "aws_s3_bucket" "backend" {
  count = var.create_vpc ? 1 : 0

  bucket = lower("s3-${var.env}-${random_integer.s3.result}-${var.backend_region}")

  tags = {
    Name        = "My bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket" "backend_log" {
  count = var.create_vpc ? 1 : 0

  bucket = lower("s3-${var.env}-${random_integer.s3.result}-${var.backend_region}-log")

  tags = {
    Name        = "My bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = lower("s3-${var.env}-${random_integer.s3.result}-${var.source_region}")

  tags = {
    Name        = "My bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket" "source_log" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = lower("s3-${var.env}-${random_integer.s3.result}-${var.source_region}-log")

  tags = {
    Name        = "My bucket"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.source
  count    = var.create_vpc ? 1 : 0
  bucket   = aws_s3_bucket.source[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source[count.index].id

  rule {
    id = "foobar"

    filter {
      prefix = "foo"
    }

    status = "Enabled"

    source_selection_criteria {
      replica_modifications {
        status = "Enabled"
      }
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket        = aws_s3_bucket.backend[count.index].arn
      storage_class = "STANDARD"
      encryption_configuration {
        replica_kms_key_id = aws_kms_key.mykey.arn

      }
      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }

      metrics {
        event_threshold {
          minutes = 15
        }
        status = "Enabled"
      }
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}

# Ensure that an S3 bucket has a lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id
  rule {
    id     = "backend-rule"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }

}

resource "aws_s3_bucket_lifecycle_configuration" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id
  rule {
    id     = "backend-rule"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }

}

# Ensure that S3 bucket has a Public Access block
resource "aws_s3_bucket_public_access_block" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id

  target_bucket = aws_s3_bucket.backend_log[count.index].id
  target_prefix = "log/"
}

resource "aws_s3_bucket_logging" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id

  target_bucket = aws_s3_bucket.source_log[count.index].id
  target_prefix = "log/"
}

#4. Random integer
resource "random_integer" "s3" {
  max = 100
  min = 1

  keepers = {
    bucket_env = var.env
  }
}

#5. KMS for bucket encryption
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_key" "mykey_source" {
  provider                = aws.source
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

#  "Ensure KMS key Policy is defined"
resource "aws_kms_key_policy" "mykey" {
  key_id = aws_kms_key.mykey.id
  policy = data.aws_iam_policy_document.kms_key_policy.json
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_kms_key_policy" "mykey_source" {
  provider = aws.source
  key_id   = aws_kms_key.mykey_source.id
  policy   = data.aws_iam_policy_document.kms_key_policy.json
  lifecycle {
    create_before_destroy = true
  }
}

#6. Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey_source.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Ensure S3 buckets should have event notifications enabled
resource "aws_sqs_queue" "queue" {
  name              = "s3-event-notification-queue"
  kms_master_key_id = aws_kms_key.mykey.arn
  policy            = data.aws_iam_policy_document.queue.json
}

resource "aws_sqs_queue" "queue_source" {
  provider          = aws.source
  kms_master_key_id = aws_kms_key.mykey_source.arn
  name              = "s3-event-notification-queue"
  policy            = data.aws_iam_policy_document.queue.json
}

resource "aws_s3_bucket_notification" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id

  queue {
    queue_arn = aws_sqs_queue.queue.arn
    events = ["s3:ObjectCreated:*",
      "s3:LifecycleTransition",
      "s3:LifecycleExpiration:*",
      "s3:ObjectRemoved:*",
      "s3:ObjectRestore:*",
    "s3:Replication:*"]
    filter_suffix = ".log"
  }
}

resource "aws_s3_bucket_notification" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id

  queue {
    queue_arn = aws_sqs_queue.queue_source.arn
    events = ["s3:ObjectCreated:*",
      "s3:LifecycleTransition",
      "s3:LifecycleExpiration:*",
      "s3:ObjectRemoved:*",
      "s3:ObjectRestore:*",
    "s3:Replication:*"]
    filter_suffix = ".log"
  }
}
