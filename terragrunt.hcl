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
      labels     = ["folder:This/is/a/test/folder"]
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
      labels = []
      dependsOnStacks = []
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
    "stacks/aws/example-account/us-east-1/test3" : {
      dependsOnStacks = [
            "stacks/aws/example-account/us-east-1/s3"
        ]
      labels = []
      autodeploy = false
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
    "stacks/aws/example-account/us-east-1/test" : {
      dependsOnStacks = []
      labels = []
      autodeploy = false
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
  }
}
