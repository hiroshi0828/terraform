provider "aws" {
  profile = "user1"
  region  = "ap-northeast-1"
}

module "dev_server" {
  source        = "./http_server"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
}
output "public_dns" {
  value = module.dev_server.public_dns
}

module "example_sg" {
  source      = "./security_group"
  name        = "module-sg"
  vpc_id      = aws_vpc.example.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_s3_bucket" "private" {
  bucket = "private-pragmatic-terraform-on-hiroshi"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket" "public-hiroshi" {
  bucket = "public-pragmatic-terraform-on-aws-hiroshi"
  acl    = "public-read"

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-pragmatic-terraform-on-hiroshi"
  lifecycle_rule {
    enabled = true
    expiration {
      days = "180"
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"]
    }
  }
}

resource "aws_s3_bucket" "force_destroy" {
  bucket        = "force-destory-pragmatic-terraform-on-hiroshi"
  force_destroy = true
}
