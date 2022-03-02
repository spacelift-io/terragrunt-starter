terraform {
  source = "./"
}

inputs = {
  spacelift_account_name = "change-to-name-of-your-spacelift-account"
  repository_name        = "terragrunt-starter"
  repository_branch      = "main"
  stacks                 = {
    # Spacelift related
    "stacks/_spacelift/policies/access/engineering-read" : {
      administrative       = true # Setting this to true because this example creates a Spacelift policy, which is a Spacelift reseource. Stacks that create Spacelift resources need administrative set to true.
      autodeploy           = false # Setting this to false, which will ensure that approvals are required before deployments.
      enable_local_preview   = false # This is an optional setting that would enable you to send emulated runs to this stack from the Spacelift CLI. More info: https://docs.spacelift.io/concepts/stack/stack-settings#enable-local-preview
      create_own_iam_role     = false # This is an optional setting that would create a separate IAM role for this stack to use (by default all stacks utilize a shared role that we created in the root main.tf)
      setup_aws_integration  = true # This is an optional setting that allows you to disable configuring the AWS integration for this stack.
      description          = "Creates a Spacelift Access Policy that gives the engineering team read access to stacks."
      additional_labels     = [] # Any additional Spacelift labels to apply to the stack, by default we apply the "terragrunt" and "managed" labels
      attachment_policy_ids  = [] # Any additional Spacelift policy ids to apply to the stack, by default we attach ignore changes outside root and trigger dependencies (defined in main.tf)
      attachment_context_ids = [] # Any additional Spacelift context ids to apply to the stack, by default we attach a single shared context (defined in main.tf)
      depends_on_stacks      = [] # The names of any stacks that this stack depends on
    },
    "stacks/_spacelift/policies/login/devops-are-admins" : {
      administrative       = true
      autodeploy           = false
      enable_local_preview   = false
      create_own_iam_role     = false
      setup_aws_integration  = true
      description          = "Creates a Spacelift Login Policy that gives the DevOps team admin access to this Spacelift account."
      additional_labels     = []
      attachment_policy_ids  = []
      attachment_context_ids = []
      depends_on_stacks      = []
    }
  }
}
