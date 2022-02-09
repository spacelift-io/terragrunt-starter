resource "aws_s3_bucket" "this" {
  bucket = "spitzzz-testing-spacelift-bucket-3"
  acl    = "private"

  tags = {
    Name        = "spitzzz-testing-spacelift-bucket-3",
    Turtle      = "true"
  }
}
