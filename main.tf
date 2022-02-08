data "spacelift_current_stack" "this" {}

// IAM Role to be used by Managed Stacks
resource "aws_iam_role" "spacelift" {
  name = "spitzzz-terragrunt-starter-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Condition": {
              "StringLike": {
                "sts:ExternalId": "spitzzz@*"
              }
            },
            "Effect": "Allow",
            "Principal": {
              "AWS": "324880187172"
            }
        }
    ]
  })
}

resource "spacelift_stack" "managed" {
  name        = "terragrunt-starter/root/test/us-east-1/s3"
  description = "Your first stack managed by Terraform"

  repository   = "terragrunt-starter"
  branch       = "main"
  project_root = "./root/test/us-east-1/s3"

  manage_state = true
  autodeploy   = true
  labels       = ["managed", "terragrunt"]
}
// "depends-on:${data.spacelift_current_stack.this.id}"


// Stack Role Attachment
resource "spacelift_aws_role" "credentials" {
  stack_id = spacelift_stack.managed.id
  role_arn = aws_iam_role.spacelift.arn
}

// Stack Policy Attachment
// resource "spacelift_policy_attachment" "no-weekend-deploys" {
//   policy_id = "ignore-commits-outside-the-project-root"
//   stack_id  = spacelift_stack.managed.id
// }
