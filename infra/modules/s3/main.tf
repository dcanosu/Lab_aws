resource "aws_s3_bucket" "this" {
    bucket = var.bucket_name
    
    tags = {
      Name = "App-Hosting-Bucket"
      Environment = "Prod"
    }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_encryption" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_distribution_arn]
    }
  }
}

locals {
  mime_types = {
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "json" = "application/json"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "svg"  = "image/svg+xml"
  }
}

resource "aws_s3_object" "webapp_files" {
  for_each = fileset("${path.module}/../../app", "**/*")
  

  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/../../app/${each.value}"
  
  # Usamos el mapa local y extraemos la extensión de forma más limpia
  content_type = lookup(local.mime_types, lower(reverse(split(".", each.value))[0]), "application/octet-stream")

  # El etag es clave: si el archivo cambia localmente, Terraform lo resubirá
  etag = filemd5("${path.module}/../../app/${each.value}")
}

resource "null_resource" "upload_app_files" {
  triggers = {
    # Cambiamos a tres niveles: ../../../
    folder_hash = sha1(join("", [for f in fileset("${path.module}/../../../app", "**/*") : filemd5("${path.module}/../../../app/${f}")]))
  }

  provisioner "local-exec" {
    # Cambiamos a tres niveles: ../../../
    command = "aws s3 sync ${abspath("${path.module}/../../../app")} s3://${aws_s3_bucket.this.id} --delete --profile terraform"
  }

  depends_on = [aws_s3_bucket.this]
}