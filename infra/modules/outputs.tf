provider "aws" {
  region  = "us-east-1"
  profile = "terraform" # Tu usuario con permisos granulares
}

# ... tus módulos ...


output "website_url" {
  description = "URL de la aplicación en CloudFront"
  value       = "https://${module.cloud_front.cloudfront_url}"
}