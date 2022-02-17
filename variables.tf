variable "spaceliftAccountName" {
  type        = string
  description = "The name of the Spacelift account you are using."
}

variable "repositoryName" {
  type        = string
  description = "The name of the Git repository for this terragrunt-starter."
}

variable "repositoryBranch" {
  type        = string
  description = "The name of the branch to use for the specified Git repository."
}

variable "stacks" {
  type = map(object({
    autodeploy           = bool,
    additional_labels    = list(string)
    dependsOnStacks      = list(string)
    terraform_version    = string
    enable_local_preview = bool
    worker_pool_id       = string
    administrative       = bool
    description          = string
    createIamRole        = bool
    setupAwsIntegration  = bool
    executionRoleArn     = optional(string)
    attachmentPolicyIds  = list(string)
    attachmentContextIds = list(string)
  }))
  default = {}
}

variable "test" {
  type = map(object({
    autodeploy           = bool,
    additional_labels    = list(string)
    dependsOnStacks      = list(string)
    terraform_version    = string
    enable_local_preview = bool
    worker_pool_id       = string
    administrative       = bool
    description          = string
    createIamRole        = bool
    setupAwsIntegration  = bool
    executionRoleArn     = optional(string)
    attachmentPolicyIds  = list(string)
    attachmentContextIds = list(string)
  }))
  default = {
    # Spacelift related
    "stacks/_spacelift/policies/trigger/new-stack-trigger" : {
      administrative       = true
      autodeploy           = false
      enable_local_preview = false
      createIamRole        = false
      setupAwsIntegration  = true
      terraform_version    = ""
      worker_pool_id       = ""
      description          = ""
      additional_labels    = []
      attachmentPolicyIds  = []
      attachmentContextIds = []
      dependsOnStacks      = []
      executionRoleArn     = "test"
    }
  }
}
