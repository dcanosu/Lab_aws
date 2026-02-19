output "distribution_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "El ARN de la distribución para que S3 lo reconozca en su política"
}

output "distribution_id" {
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.this.domain_name
}