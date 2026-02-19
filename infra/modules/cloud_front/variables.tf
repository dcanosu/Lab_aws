variable "s3_bucket_domain_name" {
  description = "El domain name regional del bucket de S3 (ej. bucket-name.s3.us-east-1.amazonaws.com)"
  type        = string
}

variable "s3_bucket_id" {
  description = "El ID del bucket para la política de acceso"
  type        = string
}