// IAM Role to be used by Managed Stacks
resource "aws_iam_role" "spacelift" {
  name = "spacelift-${var.spaceliftAccount}-terragrunt-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringLike" : {
            "sts:ExternalId" : "${var.spaceliftAccount}@*"
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

resource "spacelift_stack" "managed" {
  for_each    = var.stacks
  name        = each.key
  description = "Terragrunt stack managed by Spacelift."

  repository   = var.repositoryName
  branch       = var.repositoryBranch
  project_root = each.key

  manage_state = true
  autodeploy   = each.value.autodeploy
  labels = concat([
    "managed",
    "terragrunt"
    ],
    formatlist("depends-on:%s", each.value.dependsOnStacks)
  )
}

// Stack Role Attachment
resource "spacelift_aws_role" "credentials" {
  depends_on = [
    spacelift_stack.managed
  ]
  for_each = spacelift_stack.managed
  stack_id = spacelift_stack.managed[each.key].id
  role_arn = aws_iam_role.spacelift.arn
}

// // Stack Policy Attachment
resource "spacelift_policy_attachment" "policy-attach-ignore-commits-outside-root" {
  depends_on = [
    spacelift_stack.managed
  ]
  for_each  =  spacelift_stack.managed
  policy_id = "ignore-commits-outside-the-project-root"
  stack_id  = spacelift_stack.managed[each.key].id
}

resource "spacelift_policy_attachment" "policy-attachment-trigger-dependencies" {
  depends_on = [
    spacelift_stack.managed
  ]
  for_each  = spacelift_stack.managed
  policy_id = "trigger-stacks-that-declare-an-explicit-dependency"
  stack_id  = spacelift_stack.managed[each.key].id
}
