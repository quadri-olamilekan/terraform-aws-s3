output "destination_bucket" {
  value = module.s3-bucket.destination_bucket
}

output "source_bucket" {
  value = module.s3-bucket.source_bucket
}

output "sqs_queue_destination_url" {
  value = module.s3-bucket.sqs_queue_destination_url
}

output "sqs_queue_source_url" {
  value = module.s3-bucket.sqs_queue_source_url
}