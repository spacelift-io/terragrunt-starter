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
    # autodeploy           = string,
    # additional_labels    = list(string)
    # dependsOnStacks      = list(string)
    # terraform_version    = string
    # enable_local_preview = bool
    # worker_pool_id       = string
    # administrative       = bool
    # description          = string
    # createIamRole        = bool
    # setupAwsIntegration  = bool
    # executionRoleArn     = string
    # attachmentPolicyIds  = list(string)
    # attachmentContextIds = list(string)
  }))
  default = {}
}
