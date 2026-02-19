output "s3_bucket_id" {
  value       = aws_s3_bucket.terraform_state.id
  description = "Copia este valor en el campo 'bucket' de tu configuración de backend"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "Copia este valor en el campo 'dynamodb_table' de tu configuración de backend"
}

output "terraform_state_region" {
  value       = "us-east-1"
  description = "La región para el bloque backend"
}