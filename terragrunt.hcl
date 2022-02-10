terraform {
  source = "./"
}

inputs = {
  spaceliftAccount ="spitzzz"
  repositoryName   = "terragrunt-starter"
  repositoryBranch = "main"
  stacks           = {
    // "stacks/_spacelift/policies/trigger/new-stack-trigger" : {
    //   dependsOnPaths = []
    //   autodeploy = false
    // }
    "stacks/aws/example-account/us-east-1/s3" : {
        dependsOnPaths = []
        autodeploy = false
    }
    "stacks/aws/example-account/us-east-1/test3" : {
        dependsOnPaths = [
            "aws/test/us-east-1/s3"
        ]
        autodeploy = false
    }
    "stacks/aws/example-account/us-east-1/test" : {
        dependsOnPaths = []
        autodeploy = false
    }
  }
}
