resource "aws_s3_bucket" "this" {
  bucket = "spitzzz-testing-spacelift-bucket-2"
  acl    = "private"

  tags = {
    Name        = "spitzzz-testing-spacelift-bucket-2",
    Turtle      = "true"
  }
}

// This is a testasdf