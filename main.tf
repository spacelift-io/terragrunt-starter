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
  count               = var.createIamRole ? 1 : 0
  name                = "spacelift-${var.spaceliftAccountName}-terragrunt-role"
  managed_policy_arns = var.iamRolePolicyArns
  assume_role_policy  = jsonencode({
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
          "AWS" : [ 
              "arn:aws:iam::324880187172:root",
              "arn:aws:iam::130709053555:root" # TODO: REMOVE BEFORE MERGING (Spacelift preprod)
          ]
        }
      }
    ]
  })
}

# Policies
module "policy-ignore-changes-outside-project-root" {
  source   = "spacelift.dev/spacelift-io/policy/spacelift"
  version  = "0.0.2"

  # Inputs
  name = "(Terragrunt) Ignore changes outside project root."
  body = file("_spacelift/policies/ignore-changes-outside-project-root.rego")
  type = "GIT_PUSH"
}

module "policy-trigger-dependencies" {
  source   = "spacelift.dev/spacelift-io/policy/spacelift"
  version  = "0.0.2"

  # Inputs
  name = "(Terragrunt) Trigger dependencies."
  body = file("_spacelift/policies/trigger-dependencies.rego")
  type = "TRIGGER"
}

# Shared Context
resource "spacelift_context" "shared" {
  description = "A context meant to be shared with many stacks."
  name        = "${var.spaceliftAccountName}-shared-context"
}

# Stack(s)
module "stack" {
  depends_on = [
    aws_iam_role.spacelift,
    module.policy-ignore-changes-outside-project-root,
    module.policy-trigger-dependencies
  ]
  # Create a stack for each stack input
  for_each = var.stacks
  source   = "spacelift.dev/spacelift-io/stack/spacelift"
  version  = "0.2.1"

  # Inputs
  name                 = each.key
  projectRoot          = each.key
  spaceliftAccountName = var.spaceliftAccountName
  repositoryName       = var.repositoryName
  repositoryBranch     = var.repositoryBranch
  description          = lookup(var.stacks[each.key], "description", "Terragrunt stack managed by Spacelift.")
  terraformVersion     = var.stacks[each.key].terraformVersion == null ? "" : var.stacks[each.key].terraformVersion
  enableLocalPreview   = lookup(var.stacks[each.key], "enableLocalPreview", false)
  workerPoolId         = var.stacks[each.key].workerPoolId == null ? "" : var.stacks[each.key].workerPoolId
  administrative       = lookup(var.stacks[each.key], "administrative", false)
  autodeploy           = lookup(var.stacks[each.key], "autodeploy", false)
  createIamRole        = var.stacks[each.key].createOwnIamRole == null ? false : var.stacks[each.key].createOwnIamRole
  setupAwsIntegration  = lookup(var.stacks[each.key], "setupAwsIntegration", true)
  executionRoleArn     = var.stacks[each.key].executionRoleArn == null ? aws_iam_role.spacelift[0].arn : var.stacks[each.key].executionRoleArn
  attachmentPolicyIds  = concat(
    [ 
      module.policy-trigger-dependencies.id,
      module.policy-ignore-changes-outside-project-root.id
    ],
    lookup(var.stacks[each.key], "attachmentPolicyIds", [])
  )
  attachmentContextIds = concat(
    [
      spacelift_context.shared.id
    ],
    lookup(var.stacks[each.key], "attachmentContextIds", [])
  )
  labels = concat(
    ["managed", "terragrunt"],
    # Dynamically add dependencies if they are specified
    # Note: Requires trigger dependencies policies for labels to trigger dependencies
    formatlist("depends-on:%s", lookup(var.stacks[each.key], "dependsOnStacks")),
    # Dynamically generate Spacelift label folders to organize stacks based on their actual folder path
    # Note: This assumes your terragrunt structure begins one level deep as it does in this example under "stacks"
    [join("", ["folder:", join("/", slice(split("/", each.key), 1, length(split("/", each.key))))])],
    lookup(var.stacks[each.key], "additionalLabels", [])
  )
}
