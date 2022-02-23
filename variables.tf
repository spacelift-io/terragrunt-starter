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
    additionalLabels     = list(string)
    dependsOnStacks      = list(string)
    terraformVersion     = optional(string)
    enableLocalPreview   = bool
    workerPoolId         = optional(string)
    administrative       = bool
    description          = string
    createOwnIamRole     = bool
    setupAwsIntegration  = bool
    executionRoleArn     = optional(string)
    attachmentPolicyIds  = list(string)
    attachmentContextIds = list()
  }))
  default = {}
}
