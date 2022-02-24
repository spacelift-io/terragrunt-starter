terraform {
  source = "./"
}

inputs = {
  spaceliftAccountName = "spacelift-io"
  repositoryName       = "terragrunt-starter"
  repositoryBranch     = "main"
  stacks               = {
    # Spacelift related
    "stacks/_spacelift/policies/trigger/trigger-new-stacks" : {
      administrative       = true
      autodeploy           = false
      enableLocalPreview   = false
      createOwnIamRole     = false
      setupAwsIntegration  = true
      description          = "Creates a Spacelift trigger policy that can be used to trigger new stacks upon creation."
      additionalLabels     = []
      attachmentPolicyIds  = []
      attachmentContextIds = []
      dependsOnStacks      = []
    },
  }
}
