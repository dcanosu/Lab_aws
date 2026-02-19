# infra/modules/main.tf

terraform {
  backend "s3" {
    bucket         = "terraform-state-dcanosu-tf" # El que creaste en infra/backend
    key            = "proyectos/mi-web/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

# Llamada al módulo S3 (Para los archivos de la APP, NO del estado)
module "s3_app" {
  source      = "./s3"
  bucket_name = "mi-bucket-app-index-html"
  cloudfront_distribution_arn = module.cloud_front.distribution_arn
}

# Llamada al módulo CloudFront
module "cloud_front" {
  source                = "./cloud_front"
  s3_bucket_domain_name = module.s3_app.bucket_regional_domain_name
  s3_bucket_id          = module.s3_app.bucket_id
}