terraform {
  source = "./"
}

inputs = {
  spaceliftAccountName = "spacelift-io"
  repositoryName       = "terragrunt-starter"
  repositoryBranch     = "main"
  stacks               = {
    # Spacelift related
    "stacks/_spacelift/policies/trigger/new-stack-trigger" : {
      administrative       = true
      autodeploy           = false
      enable_local_preview = false
      createOwnIamRole     = false
      setupAwsIntegration  = true
      description          = "Creates a Spacelift trigger policy that triggers new stacks upon creation."
      additional_labels    = []
      attachmentPolicyIds  = []
      attachmentContextIds = []
      dependsOnStacks      = []
    }
    # Example Account
    # us-east-1
    "stacks/aws/example-account/us-east-1/s3/buckets/example-spacelift-bucket" : {
      administrative       = false
      autodeploy           = false
      enable_local_preview = false
      createOwnIamRole     = false
      setupAwsIntegration  = true
      description          = "Creates an example Spacelift bucket."
      additional_labels    = []
      attachmentPolicyIds  = []
      attachmentContextIds = []
      dependsOnStacks      = []
    }
  }
}
