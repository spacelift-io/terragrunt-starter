data "spacelift_current_stack" "this" {}

locals {
  paths = [
    "root/test/us-east-1/s3",
    "root/test/us-east-1/test"
  ]
}

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
  count       = length(local.paths)
  name        = element(local.paths, count.index)
  description = "Terragrunt stack."

  repository   = "terragrunt-starter"
  branch       = "main"
  project_root = element(local.paths, count.index)

  manage_state = true
  autodeploy   = false
  labels       = ["managed", "terragrunt"]
}
// "depends-on:${data.spacelift_current_stack.this.id}"


// Stack Role Attachment
resource "spacelift_aws_role" "credentials" {
  stack_id = spacelift_stack.managed[count.index].id
  role_arn = aws_iam_role.spacelift.arn
}

// // Stack Policy Attachment
// resource "spacelift_policy_attachment" "no-weekend-deploys" {
//   policy_id = "only-track-tf-and-hcl-changes-in-the-absolute-root"
//   stack_id  = spacelift_stack.managed.id
// }
