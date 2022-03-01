terraform {
  source = "./"
}

inputs = {
  spacelift_account_name = "spacelift-io"
  repository_name       = "terragrunt-starter"
  repository_branch     = "main"
  stacks               = {
    # Spacelift related
    "stacks/_spacelift/policies/access/engineering-read" : {
      administrative       = true
      autodeploy           = false
      enable_local_preview   = false
      create_own_iam_role     = false
      setup_aws_integration  = true
      description          = "Creates a Spacelift Access Policy that gives the engineering team read access to stacks."
      additional_labels     = [
        "turtle"
      ]
      attachment_policy_ids  = []
      attachment_context_ids = []
      depends_on_stacks      = [
        "stacks/_spacelift/policies/login/devops-are-admins"
      ]
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
    },
  }
}
