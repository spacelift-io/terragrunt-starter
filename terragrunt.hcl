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
    }
    "stacks/aws/example-account/us-east-1/s3" : {
        autodeploy = false
    }
    "stacks/aws/example-account/us-east-1/test3" : {
        dependsOnStacks = [
            "stacks/aws/example-account/us-east-1/s3"
        ]
        autodeploy = false
    }
    "stacks/aws/example-account/us-east-1/test" : {
        autodeploy = false
    }
  }
}
