data "spacelift_current_stack" "this" {}

resource "spacelift_stack" "managed" {
  name        = "terragrunt-starter/root/test/us-east-1/s3"
  description = "Your first stack managed by Terraform"

  repository   = "terragrunt-starter"
  branch       = "main"
  project_root = "./root/test/us-east-1/s3"

  autodeploy = true
  labels     = ["managed", "terragrunt", "depends-on:${data.spacelift_current_stack.this.id}"]
}

// Configure stack to use the role
resource "spacelift_aws_role" "credentials" {
  depends_on = [
    spacelift_stack.managed
  ]
  stack_id                       = "terragrunt-starter-root-test-us-east-1-s3"
  role_arn                       = aws_iam_role.spacelift.arn
  generate_credentials_in_worker = true
}

resource "aws_iam_role" "spacelift" {
  name = "spitzzz-terragrunt-starter-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringLike" : {
            "sts:ExternalId" : "spitzzz@*"
          }
        },
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "324880187172"
        }
      }
    ]
  })
}