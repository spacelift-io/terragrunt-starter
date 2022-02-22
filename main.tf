# Shared Context Used By All Stacks Deployed
resource "spacelift_context" "shared" {
  name        = "Shared"
  description = "Shared context used by all stacks deployed by ${var.repositoryName}"
}

// IAM Role to allow stacks to deploy resources on AWS
# This role is always created and used by all stacks by default,
# but you can configure the module to create independent IAM roles per-stack
# by using the following for a given stack's map configuration:
# setupAwsIntegration: true
# createOwnIamRole: true
# ------
# OR you can optionally specify your own role to use for a given stack
# by using the following for a given stack's map configuration:
# setupAwsIntegration: true
# createOwnIamRole: false
# executionRoleArn: "ROLE_ARN_YOU_WANT_TO_USE_HERE"
resource "aws_iam_role" "spacelift" {
  name = "spacelift-${var.spaceliftAccountName}-terragrunt-role"
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
            "sts:ExternalId" : "${var.spaceliftAccountName}@*"
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

module "stack" {
  depends_on = [
    aws_iam_role.spacelift
  ]
  # Create a stack for each stack input
  for_each = var.stacks
  source   = "spacelift.dev/spacelift-io/stack/spacelift"
  version  = "0.0.1"

  # Inputs
  name                 = each.key
  spaceliftAccountName = var.spaceliftAccountName
  repositoryName       = var.repositoryName
  repositoryBranch     = var.repositoryBranch
  description          = lookup(var.stacks[each.key], "description", "Terragrunt stack managed by Spacelift.")
  terraform_version    = var.stacks[each.key].terraform_version == null ? "" : var.stacks[each.key].terraform_version
  enable_local_preview = lookup(var.stacks[each.key], "enable_local_preview", false)
  worker_pool_id       = var.stacks[each.key].worker_pool_id == null ? "" : var.stacks[each.key].worker_pool_id
  administrative       = lookup(var.stacks[each.key], "administrative", false)
  autodeploy           = lookup(var.stacks[each.key], "autodeploy", false)
  createIamRole        = var.stacks[each.key].createOwnIamRole == null ? false : var.stacks[each.key].createOwnIamRole
  setupAwsIntegration  = lookup(var.stacks[each.key], "setupAwsIntegration", true)
  executionRoleArn     = var.stacks[each.key].executionRoleArn == null ? aws_iam_role.spacelift.arn : var.stacks[each.key].executionRoleArn
  attachmentPolicyIds  = lookup(var.stacks[each.key], "attachmentPolicyIds", [])
  attachmentContextIds = [
    concat(
      tolist(spacelift_context.shared.id),
      lookup(var.stacks[each.key], "attachmentContextIds", [])
    )
  ]
  project_root         = each.key
  labels = concat(
    ["managed", "terragrunt"],
    # Dynamically add dependencies if they are specified
    # Note: Requires trigger dependencies policies for labels to trigger dependencies
    formatlist("depends-on:%s", lookup(var.stacks[each.key], "dependsOnStacks")),
    # Dynamically generate Spacelift label folders to organize stacks based on their actual folder path
    # Note: This assumes your terragrunt structure begins one level deep as it does in this example under "stacks"
    [join("", ["folder:", join("/", slice(split("/", each.key), 1, length(split("/", each.key))))])],
    lookup(var.stacks[each.key], "additional_labels", [])
  )
}

