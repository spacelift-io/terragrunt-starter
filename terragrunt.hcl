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
      autodeploy = false
      additional_labels     = []
      dependsOnStacks = []
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
    # Example Account
    # us-east-1
    "stacks/aws/example-account/us-east-1/s3" : {
      autodeploy = false
      additional_labels = []
      dependsOnStacks = []
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
    "stacks/aws/example-account/us-east-1/test3" : {
      dependsOnStacks = [
            "stacks/aws/example-account/us-east-1/s3",
            "stacks/aws/example-account/us-east-1/test"
        ]
      additional_labels = []
      autodeploy = false
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
    "stacks/aws/example-account/us-east-1/test" : {
      dependsOnStacks = []
      additional_labels = []
      autodeploy = false
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
  }
}
