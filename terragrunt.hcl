terraform {
  source = "./"
}

inputs = {
  spaceliftAccountName = "spacelift-io"
  repositoryName       = "terragrunt-starter"
  repositoryBranch     = "main"
  stacks               = {
    # Spacelift related
    # "stacks/_spacelift/policies/access/engineering-read" : {
    #   administrative       = true
    #   autodeploy           = false
    #   enableLocalPreview   = false
    #   createOwnIamRole     = false
    #   setupAwsIntegration  = true
    #   description          = "Creates a Spacelift Access Policy that gives the engineering team read access to stacks."
    #   additionalLabels     = []
    #   attachmentPolicyIds  = []
    #   attachmentContextIds = []
    #   dependsOnStacks      = []
    # },
    # "stacks/_spacelift/policies/login/devops-are-admins" : {
    #   administrative       = true
    #   autodeploy           = false
    #   enableLocalPreview   = false
    #   createOwnIamRole     = false
    #   setupAwsIntegration  = true
    #   description          = "Creates a Spacelift Login Policy that gives the DevOps team admin access to this Spacelift account."
    #   additionalLabels     = []
    #   attachmentPolicyIds  = []
    #   attachmentContextIds = []
    #   dependsOnStacks      = []
    # },
  }
}
