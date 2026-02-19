#!/bin/bash
set -e # Stpop the script if any command fails
export AWS_PAGER=""

ADMIN_PROFILE="admin-dcanosu"
TERRAFORM_PROFILE="terraform"
POLICY_NAME="TerraformDirectPolicy"

echo "Executing minimun permissions to terraform user for S3, DynamoDB and IAM. This is required for Terraform to work with the backend and manage resources."
export AWS_PROFILE=$ADMIN_PROFILE

ACCOUNT_ID=$(aws sts get-caller-identity --profile $ADMIN_PROFILE --query "Account" --output text)
POLICY_ARN="arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME"

if ! aws iam get-policy --policy-arn $POLICY_ARN --profile $ADMIN_PROFILE > /dev/null 2>&1; then
    echo "Creando política personalizada desde terraform-policy.json..."
    aws iam create-policy --policy-name $POLICY_NAME --policy-document file://terraform-policy.json --profile $ADMIN_PROFILE
else
    echo "La política $POLICY_NAME ya existe."
fi

aws iam attach-user-policy --user-name terraform --policy-arn $POLICY_ARN --profile $ADMIN_PROFILE

echo "Executing Terraform Backend"

cd infra/backend
export AWS_PROFILE=$TERRAFORM_PROFILE

terraform init -reconfigure
terraform plan --out=tfplan

# terraform show -json tfplan > tfplan.json
terraform show -no-color tfplan > tfplan.txt

terraform apply -auto-approve tfplan
# # Al final de tu proceso exitoso:
# aws iam detach-user-policy --user-name terraform --profile $ADMIN_PROFILE --policy-arn $POLICY_ARN
# Quitar las políticas FullAccess (Las que dicen 'Directly')
aws iam detach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --profile admin-dcanosu
aws iam detach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess --profile admin-dcanosu
aws iam detach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --profile admin-dcanosu