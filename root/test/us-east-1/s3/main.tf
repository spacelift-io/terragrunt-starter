resource "aws_s3_bucket" "this" {
  bucket = "spitzzz-testing-spacelift-bucket"
  acl    = "private"

  tags = {
    Name        = "spitzzz-testing-spacelift-bucket",
    Turtle      = "true"
  }
}

// This is a test