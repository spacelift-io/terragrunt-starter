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
  for_each    = local.stacks
  name        = each.key
  description = "Terragrunt stack."

  repository   = "terragrunt-starter"
  branch       = "main"
  project_root = each.key

  manage_state = true
  autodeploy   = each.value.autodeploy
  labels       = concat([
    "managed", 
    "terragrunt"
  ], 
    formatlist("depends-on:%s", each.value.dependsOnPaths)
  )
}

// Stack Role Attachment
resource "spacelift_aws_role" "credentials" {
  depends_on  = [
    spacelift_stack.managed
  ]
  count       = length(local.stacks)
  stack_id    = values(spacelift_stack.managed)[count.index].id
  role_arn    = aws_iam_role.spacelift.arn
}

// // Stack Policy Attachment
resource "spacelift_policy_attachment" "policy-attachment" {
  depends_on  = [
    spacelift_stack.managed
  ]
  count       = length(local.stacks)
  policy_id   = "ignore-commits-outside-the-project-root"
  stack_id    = values(spacelift_stack.managed)[count.index].id
}
