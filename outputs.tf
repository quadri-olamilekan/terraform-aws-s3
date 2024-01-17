output "destination_bucket" {
  value       = aws_s3_bucket.backend[0].bucket
  description = "The name of the destination S3 bucket"
}

output "source_bucket" {
  value       = aws_s3_bucket.source[0].bucket
  description = "The name of the source S3 bucket"
}

output "sqs_queue_destination_url" {
  value       = aws_sqs_queue.queue.id
  description = "The URL of the SQS queue associated with the destination S3 bucket"
}

output "sqs_queue_source_url" {
  value       = aws_sqs_queue.queue_source.id
  description = "The URL of the SQS queue associated with the source S3 bucket"
}
