provider "aws" {
  region = var.backend_region
}

provider "aws" {
  alias  = "source"
  region = var.source_region
}

resource "random_integer" "s3" {
  max = var.max_int
  min = var.min_int

  keepers = {
    bucket_name = var.bucket_name
  }
}

resource "aws_iam_role" "replication" {
  provider           = aws.source
  name               = var.aws_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "replication" {
  provider = aws.source
  name     = var.aws_iam_role_policy_attachment_name
  policy   = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  provider   = aws.source
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket" "backend" {
  count = var.create_vpc ? 1 : 0

  bucket = lower("s3-${var.bucket_name}-${random_integer.s3.result}-destination")

  tags = var.tag_backend
}

resource "aws_s3_bucket" "backend_log" {
  count = var.create_vpc ? 1 : 0

  bucket = lower("s3-${var.bucket_name}-${random_integer.s3.result}-destination-log")

  tags = var.tag_backend
}

resource "aws_s3_bucket" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = lower("s3-${var.bucket_name}-${random_integer.s3.result}-source")

  tags = var.tag_source
}

resource "aws_s3_bucket" "source_log" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = lower("s3-${var.bucket_name}-${random_integer.s3.result}-source-log")

  tags = var.tag_source
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
    status = var.versioning
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source

  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source[count.index].id

  rule {
    id = var.rep_rule_id

    filter {
      prefix = var.rule_filter
    }

    status = var.rep_rule_status

    source_selection_criteria {
      replica_modifications {
        status = var.replica_modifications_status
      }
      sse_kms_encrypted_objects {
        status = var.sse_kms_encrypted_objects_status
      }
    }

    destination {
      bucket        = aws_s3_bucket.backend[count.index].arn
      storage_class = var.dest_storage_class
      encryption_configuration {
        replica_kms_key_id = aws_kms_key.mykey.arn

      }
      replication_time {
        status = var.replication_time_status
        time {
          minutes = var.replication_time
        }
      }

      metrics {
        event_threshold {
          minutes = var.metrics_time
        }
        status = var.metrics_status
      }
    }

    delete_marker_replication {
      status = var.delete_marker_replication_status
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id
  rule {
    id     = var.lc_rule_id_b
    status = var.lc_rule_status_b

    transition {
      days          = var.tran_days_b
      storage_class = var.tran_sc_b
    }

    expiration {
      days = var.exp_days_b
    }
  }

}

resource "aws_s3_bucket_lifecycle_configuration" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id
  rule {
    id     = var.lc_rule_id_s
    status = var.lc_rule_status_s

    transition {
      days          = var.tran_days_s
      storage_class = var.tran_sc_s
    }

    expiration {
      days = var.exp_days_s
    }
  }

}

resource "aws_s3_bucket_public_access_block" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id

  block_public_acls       = var.block_public_acls_b
  block_public_policy     = var.block_public_policy_b
  ignore_public_acls      = var.ignore_public_acls_b
  restrict_public_buckets = var.restrict_public_buckets_b
}

resource "aws_s3_bucket_public_access_block" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id

  block_public_acls       = var.block_public_acls_s
  block_public_policy     = var.block_public_policy_s
  ignore_public_acls      = var.ignore_public_acls_s
  restrict_public_buckets = var.restrict_public_buckets_s
}

resource "aws_s3_bucket_logging" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id

  target_bucket = aws_s3_bucket.backend_log[count.index].id
  target_prefix = var.target_prefix_b
}

resource "aws_s3_bucket_logging" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id

  target_bucket = aws_s3_bucket.source_log[count.index].id
  target_prefix = var.target_prefix_s
}

# KMS for bucket encryption
resource "aws_kms_key" "mykey" {
  deletion_window_in_days = var.dwd_b
  enable_key_rotation     = var.ekr_b
}

resource "aws_kms_key_policy" "mykey" {
  key_id = aws_kms_key.mykey.id
  policy = data.aws_iam_policy_document.kms_key_policy.json
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_kms_key" "mykey_source" {
  provider                = aws.source
  deletion_window_in_days = var.dwd_s
  enable_key_rotation     = var.ekr_s
}

resource "aws_kms_key_policy" "mykey_source" {
  provider = aws.source
  key_id   = aws_kms_key.mykey_source.id
  policy   = data.aws_iam_policy_document.kms_key_policy.json
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = var.sse_algorithm
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
      sse_algorithm     = var.sse_algorithm
    }
  }
}

resource "aws_sqs_queue" "queue" {
  name              = var.sqs_b
  kms_master_key_id = aws_kms_key.mykey.arn
  policy            = data.aws_iam_policy_document.queue.json
}

resource "aws_sqs_queue" "queue_source" {
  provider          = aws.source
  name              = var.sqs_s
  kms_master_key_id = aws_kms_key.mykey_source.arn
  policy            = data.aws_iam_policy_document.queue.json
}

resource "aws_s3_bucket_notification" "backend" {
  count  = var.create_vpc ? 1 : 0
  bucket = aws_s3_bucket.backend[count.index].id

  queue {
    queue_arn     = aws_sqs_queue.queue.arn
    events        = var.event_b
    filter_suffix = var.not_suffix_b
  }
}

resource "aws_s3_bucket_notification" "source" {
  count    = var.create_vpc ? 1 : 0
  provider = aws.source
  bucket   = aws_s3_bucket.source[count.index].id

  queue {
    queue_arn     = aws_sqs_queue.queue_source.arn
    events        = var.event_s
    filter_suffix = var.not_suffix_s
  }
}
