provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket_seguro" {
  bucket = "mi-bucket-devsecops-demo-12345"
}

resource "aws_s3_bucket_public_access_block" "publico" {
  bucket                  = aws_s3_bucket.bucket_seguro.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cifrado" {
  bucket = aws_s3_bucket.bucket_seguro.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versionado" {
  bucket = aws_s3_bucket.bucket_seguro.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_security_group" "sg_seguro" {
  name        = "sg_ssh_restringido"
  description = "Grupo de seguridad restringido para el laboratorio"

  ingress {
    description = "Acceso SSH permitido solamente desde la red privada del laboratorio"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
