variable "bucket_name" {
    description = "The name of the S3 bucket"
    type        = string
    default = "My-bucket-app"
}

variable "versioning_status" {
    description = "The versioning status of the S3 bucket (Enabled or Suspended)"
    type        = string
    default     = "Enabled"
}

variable "sse_algorithm" {
    description = "The server-side encryption algorithm to use (e.g., AES256)"
    type        = string
    default     = "AES256"
}

variable "cloudfront_distribution_arn" {
  type        = string
  description = "El ARN de la distribución de CloudFront para permitir el acceso"
}