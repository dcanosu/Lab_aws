variable "dynamodb_table_name" {
    description = "The name of the DynamoDB table for Terraform state locking"
    type        = string
    default     = "terraform-state-locking"
}

variable "billing_mode" {
  description = "The billing mode for the DynamoDB table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "The name of the hash key for the DynamoDB table"
  type        = string
  default     = "LockID"
  
}