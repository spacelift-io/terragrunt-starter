// IAM Role to allow stacks to deploy resources on AWS
# This role is always created and used by all stacks by default,
# but you can configure the module to create independent IAM roles per-stack
# by using the following for a given stack's map configuration:
# setup_aws_integration: true
# create_own_iam_role: true
# ------
# OR you can optionally specify your own role to use for a given stack
# by using the following for a given stack's map configuration:
# setup_aws_integration: true
# create_own_iam_role: false
# execution_role_arn: "ROLE_ARN_YOU_WANT_TO_USE_HERE"
resource "aws_iam_role" "spacelift" {
  count               = var.create_iam_role ? 1 : 0
  name                = "spacelift-${var.spacelift_account_name}-terragrunt-role"
  managed_policy_arns = var.iam_role_policy_arns
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringLike" : {
            "sts:ExternalId" : "${var.spacelift_account_name}@*"
          }
        },
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::324880187172:root"
          ]
        }
      }
    ]
  })
}

# Policies
# Ignore changes outside root policy
module "policy-ignore-changes-outside-project-root" {
  source  = "spacelift-io/policy/spacelift"
  version = "0.0.2"

  # Inputs
  name = "(Terragrunt) Ignore changes outside project root."
  body = file("_spacelift/policies/ignore-changes-outside-project-root.rego")
  type = "GIT_PUSH"
}

# Trigger dependencies policy
module "policy-trigger-dependencies" {
  source  = "spacelift-io/policy/spacelift"
  version = "0.0.2"

  # Inputs
  name = "(Terragrunt) Trigger dependencies."
  body = file("_spacelift/policies/trigger-dependencies.rego")
  type = "TRIGGER"
}

# Shared Context
resource "spacelift_context" "shared" {
  description = "A context meant to be shared with many stacks."
  name        = "${var.spacelift_account_name}-shared-context"
}

# Adding a use of time_sleep here due to IAM eventual consistency after creating the stack shared IAM role, When
# attempting to use it with stacks we have found that on the first deployment there is an
# intermittent issue where the role cannot be used for a brief period. This is a fix for that issue
# as utilizing depends_on to enforce order was not sufficient.
resource "time_sleep" "wait-30-seconds" {
  depends_on = [aws_iam_role.spacelift]

  create_duration = "30s"
}

# Stack(s)
# Define the stacks you want to create in the root `terragrunt.hcl` file
module "stack" {
  depends_on = [
    aws_iam_role.spacelift,
    time_sleep.wait-30-seconds,
    module.policy-ignore-changes-outside-project-root,
    module.policy-trigger-dependencies
  ]
  # Create a stack for each stack input
  for_each = var.stacks
  source  = "spacelift-io/stack/spacelift"
  version  = "1.0.0"

  # Inputs
  name                   = each.key
  project_root           = each.key
  spacelift_account_name = var.spacelift_account_name
  repository_name        = var.repository_name
  repository_branch      = var.repository_branch
  description            = lookup(var.stacks[each.key], "description", "Terragrunt stack managed by Spacelift.")
  terraform_version      = var.stacks[each.key].terraform_version == null ? "" : var.stacks[each.key].terraform_version
  enable_local_preview   = lookup(var.stacks[each.key], "enable_local_preview", false)
  worker_pool_id         = var.stacks[each.key].worker_pool_id == null ? "" : var.stacks[each.key].worker_pool_id
  administrative         = lookup(var.stacks[each.key], "administrative", false)
  autodeploy             = lookup(var.stacks[each.key], "autodeploy", false)
  create_iam_role        = var.stacks[each.key].create_own_iam_role == null ? false : var.stacks[each.key].create_own_iam_role
  setup_aws_integration  = lookup(var.stacks[each.key], "setup_aws_integration", true)
  execution_role_arn     = var.stacks[each.key].execution_role_arn == null ? aws_iam_role.spacelift[0].arn : var.stacks[each.key].execution_role_arn
  attachment_policy_ids  = concat(
    [
      module.policy-trigger-dependencies.id,
      module.policy-ignore-changes-outside-project-root.id
    ],
    lookup(var.stacks[each.key], "attachment_policy_ids", [])
  )
  attachment_context_ids = concat(
    [
      spacelift_context.shared.id
    ],
    lookup(var.stacks[each.key], "attachment_context_ids", [])
  )
  labels = concat(
    ["managed", "terragrunt"],
    # Dynamically add dependencies if they are specified
    # Note: Requires trigger dependencies policies for labels to trigger dependencies
    formatlist("depends-on:%s", lookup(var.stacks[each.key], "depends_on_stacks")),
    # Dynamically generate Spacelift label folders to organize stacks based on their actual folder path
    # Note: This assumes your terragrunt structure begins one level deep as it does in this example under "stacks"
    [join("", ["folder:", join("/", slice(split("/", each.key), 1, length(split("/", each.key))))])],
    lookup(var.stacks[each.key], "additional_labels", [])
  )
}
