terraform {
  source = "./"
}

inputs = {
  spaceliftAccount = "spitzzz"
  repositoryName   = "terragrunt-starter"
  repositoryBranch = "main"
  stacks           = {
    # Spacelift related
    "stacks/_spacelift/policies/trigger/new-stack-trigger" : {
      administrative       = false
      autodeploy           = false
      enable_local_preview = false
      terraform_version    = ""
      worker_pool_id       = ""
      additional_labels    = []
      dependsOnStacks      = []
    }
    # Example Account
    # us-east-1
    "stacks/aws/example-account/us-east-1/s3" : {
      administrative       = false
      autodeploy           = false
      enable_local_preview = false
      terraform_version    = ""
      worker_pool_id       = ""
      additional_labels    = []
      dependsOnStacks      = []
    }
    "stacks/aws/example-account/us-east-1/test3" : {
      administrative       = false
      autodeploy           = false
      enable_local_preview = false
      terraform_version    = ""
      worker_pool_id       = ""
      additional_labels    = []
      dependsOnStacks      = [
            "stacks/aws/example-account/us-east-1/s3",
            "stacks/aws/example-account/us-east-1/test"
        ]
    }
    "stacks/aws/example-account/us-east-1/test" : {
      administrative       = false
      autodeploy           = false
      enable_local_preview = false
      terraform_version    = ""
      worker_pool_id       = ""
      additional_labels    = []
      dependsOnStacks      = []
    }
  }
}
