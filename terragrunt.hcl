terraform {
  source = "./"
}

inputs = {
  spaceliftAccount = "spitzzz"
  repositoryName   = "terragrunt-starter"
  repositoryBranch = "main"
  stacks           = {
    "stacks/_spacelift/policies/trigger/new-stack-trigger" : {
      autodeploy = false
      labels     = ["folder:This:Is:a:test"]
      dependsOnStacks = []
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
    "stacks/aws/example-account/us-east-1/s3" : {
      autodeploy = false
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
      autodeploy = false
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
    "stacks/aws/example-account/us-east-1/test" : {
      dependsOnStacks = []
      autodeploy = false
      terraform_version = ""
      enable_local_preview = false
      worker_pool_id = ""
      administrative = false
    }
  }
}
