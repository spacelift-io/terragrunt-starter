terraform {
  source = "./"
}

inputs = {
  spaceliftAccountName = "spitzzz"
  repositoryName   = "terragrunt-starter"
  repositoryBranch = "main"
  stacks           = {
    # Spacelift related
    "stacks/_spacelift/policies/trigger/new-stack-trigger" : {
      administrative       = true
      autodeploy           = false
      enable_local_preview = false
      createIamRole        = false
      setupAwsIntegration  = true
      terraform_version    = ""
      worker_pool_id       = ""
      description          = ""
      executionRoleArn     = null
      additional_labels    = []
      attachmentPolicyIds  = []
      attachmentContextIds = []
      dependsOnStacks      = []
    }
    # Example Account
    # us-east-1
    "stacks/aws/example-account/us-east-1/s3" : {
      administrative       = false
      autodeploy           = false
      enable_local_preview = false
      createIamRole        = false
      setupAwsIntegration  = true
      terraform_version    = ""
      worker_pool_id       = ""
      description          = ""
      executionRoleArn     = null
      additional_labels    = []
      attachmentPolicyIds  = []
      attachmentContextIds = []
      dependsOnStacks      = []
    }
    "stacks/aws/example-account/us-east-1/test3" : {
      administrative       = false
      autodeploy           = false
      enable_local_preview = false
      createIamRole        = false
      setupAwsIntegration  = true
      terraform_version    = ""
      worker_pool_id       = ""
      description          = ""
      executionRoleArn     = null
      additional_labels    = []
      attachmentPolicyIds  = []
      attachmentContextIds = []
      dependsOnStacks      = [
            "stacks/aws/example-account/us-east-1/s3",
            "stacks/aws/example-account/us-east-1/test"
        ]
    }
    "stacks/aws/example-account/us-east-1/test" : {
      administrative       = false
      autodeploy           = false
      enable_local_preview = false
      createIamRole        = false
      setupAwsIntegration  = true
      terraform_version    = ""
      worker_pool_id       = ""
      description          = ""
      executionRoleArn     = null
      additional_labels    = []
      attachmentPolicyIds  = []
      attachmentContextIds = []
      dependsOnStacks      = []
    }
  }
}
