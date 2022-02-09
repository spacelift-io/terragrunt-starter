locals {
  stacks = {
    "root/test/us-east-1/s3" : {
        dependsOnPaths = []
        autodeploy = false
    }
    "root/test/us-east-1/test3" : {
        dependsOnPaths = [
            "root/test/us-east-1/s3"
        ]
        autodeploy = false
    }
    "root/test/us-east-1/test" : {
        dependsOnPaths = []
        autodeploy = false
    }
  }
}
