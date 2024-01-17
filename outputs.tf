output "backend-name" {
  value = aws_s3_bucket.backend[0].bucket
}

output "source-name" {
  value = aws_s3_bucket.source[0].bucket
}

output "sqs_queue_url" {
  value = aws_sqs_queue.queue.id
}

output "sqs_queue_source_url" {
  value = aws_sqs_queue.queue_source.id
}