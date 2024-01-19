module "s3-bucket" {
  source         = "../../"
  backend_region = var.backend_region
  source_region  = var.source_region
  bucket_name    = var.bucket_name
}