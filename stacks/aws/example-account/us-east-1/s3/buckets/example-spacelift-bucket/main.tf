resource "random_string" "random" {
  length  = 8
  special = false
}

resource "aws_s3_bucket" "this" {
  bucket = "example-spacelift-bucket-${random_string.random.result}"
  tags   = {
    Name        = "testing-spacelift-bucket--${random_string.random.result}"
  }
}