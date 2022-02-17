# Context to use for passing GitHub Credentials
resource "spacelift_context" "shared" {
  name        = "Shared"
  description = "Shared context that contains commonly used items (e.g. git credentials)."
}

// IAM Role to allow stacks to deploy resources on AWS
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

output "test" {
  value = var.test["stacks/_spacelift/policies/trigger/new-stack-trigger"].executionRoleArn
}

# module "stack" {
#   depends_on = [
#     aws_iam_role.spacelift
#   ]
#   # Create a stack for each stack input
#   for_each = var.stacks
#   source   = "git::git@github.com:spitzzz/terraform-spacelift-stack.git?ref=0.0.2"

#   # Inputs
#   name                 = each.key
#   spaceliftAccountName = var.spaceliftAccountName
#   repositoryName       = var.repositoryName
#   repositoryBranch     = var.repositoryBranch
#   description          = lookup(var.stacks[each.key], "description", "Terragrunt stack managed by Spacelift.")
#   terraform_version    = lookup(var.stacks[each.key], "terraform_version", "")
#   enable_local_preview = lookup(var.stacks[each.key], "enable_local_preview", false)
#   worker_pool_id       = lookup(var.stacks[each.key], "worker_pool_id", "")
#   administrative       = lookup(var.stacks[each.key], "administrative", false)
#   autodeploy           = lookup(var.stacks[each.key], "autodeploy", false)
#   createIamRole        = lookup(var.stacks[each.key], "createIamRole", false)
#   setupAwsIntegration  = lookup(var.stacks[each.key], "setupAwsIntegration", true)
#   executionRoleArn     = try(var.stacks[each.key].executionRoleArn, aws_iam_role.spacelift.arn)
#   attachmentPolicyIds  = lookup(var.stacks[each.key], "attachmentPolicyIds", [])
#   attachmentContextIds = lookup(var.stacks[each.key], "attachmentContextIds", [])
#   project_root         = each.key
#   labels = concat(
#     ["managed", "terragrunt"],
#     # Dynamically add dependencies if they are specified
#     # Note: Requires trigger dependencies policies for labels to trigger dependencies
#     formatlist("depends-on:%s", lookup(var.stacks[each.key], "dependsOnStacks")),
#     # Dynamically generate Spacelift label folders to organize stacks based on their actual folder path
#     # Note: This assumes your terragrunt structure begins one level deep as it does in this example under "stacks"
#     [join("", ["folder:", join("/", slice(split("/", each.key), 1, length(split("/", each.key))))])],
#     lookup(var.stacks[each.key], "additional_labels", [])
#   )
# }

# // Spacelift stack
# # For each stack item passed into the stacks variable input, we dynamially
# # create a stack, configure its credentials, and policy attachments
# resource "spacelift_stack" "managed" {
#   for_each             = var.stacks
#   name                 = each.key
#   repository           = var.repositoryName
#   branch               = var.repositoryBranch
#   manage_state         = true
#   description          = "Terragrunt stack managed by Spacelift."
#   terraform_version    = lookup(var.stacks[each.key], "terraform_version", "")
#   enable_local_preview = lookup(var.stacks[each.key], "enable_local_preview", false)
#   worker_pool_id       = lookup(var.stacks[each.key], "worker_pool_id", "")
#   administrative       = lookup(var.stacks[each.key], "administrative", false)
#   autodeploy           = lookup(var.stacks[each.key], "autodeploy", false)
#   project_root         = each.key
#   labels = concat(
#     ["managed", "terragrunt"],
#     # Dynamically add dependencies if they are specified
#     # Note: Requires trigger dependencies policies for labels to trigger dependencies
#     formatlist("depends-on:%s", lookup(var.stacks[each.key], "dependsOnStacks")),
#     # Dynamically generate Spacelift label folders to organize stacks based on their actual folder path
#     # Note: This assumes your terragrunt structure begins one level deep as it does in this example under "stacks"
#     [join("", ["folder:", join("/", slice(split("/", each.key), 1, length(split("/", each.key))))])],
#     lookup(var.stacks[each.key], "additional_labels", [])
#   )
# }

# // Stack Role Attachment
# # Attachs the above created role to each stack
# resource "spacelift_aws_role" "credentials" {
#   depends_on = [
#     spacelift_stack.managed
#   ]
#   for_each = spacelift_stack.managed
#   stack_id = spacelift_stack.managed[each.key].id
#   role_arn = aws_iam_role.spacelift.arn
# }

# // Stack Policy Attachments
# # Attaches a policy to ignore commits outside of the stack's root directory
# # this ensures that you can maintain your stacks code independently.
# resource "spacelift_policy_attachment" "policy-attach-ignore-commits-outside-root" {
#   depends_on = [
#     spacelift_stack.managed
#   ]
#   for_each  = spacelift_stack.managed
#   policy_id = "ignore-commits-outside-the-project-root"
#   stack_id  = spacelift_stack.managed[each.key].id
# }

# # Attaches a policy which allows your stack to trigger any dependencies it has.
# # You can define your dependencies by using `dependsOnStacks` - look at the
# # terragrunt.hcl file in the root of this repository for more information.
# resource "spacelift_policy_attachment" "policy-attachment-trigger-dependencies" {
#   depends_on = [
#     spacelift_stack.managed
#   ]
#   for_each  = spacelift_stack.managed
#   policy_id = "trigger-stacks-that-declare-an-explicit-dependency"
#   stack_id  = spacelift_stack.managed[each.key].id
# }
