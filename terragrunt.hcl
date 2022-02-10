terraform {
  source = "./"
}

inputs = {
  spaceliftAccount="spitzzz"
  repositoryName  = "terragrunt-starter"
  repositoryBranch = "main"
  stacks = {
    "aws/test/us-east-1/s3" : {
        dependsOnPaths = []
        autodeploy = false
    }
    "aws/test/us-east-1/test3" : {
        dependsOnPaths = [
            "aws/test/us-east-1/s3"
        ]
        autodeploy = false
    }
    "aws/test/us-east-1/test" : {
        dependsOnPaths = []
        autodeploy = false
    }
  }
}
