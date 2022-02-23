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

variable "createIamRole" {
  type        = bool
  description = "Whether or not to create an IAM Role that can be re-used by generated stacks."
  default     = true
}

variable "iamRolePolicyArns" {
  type        = list(string)
  description = "A list of managed policy ARNs to attach to the shared IAM Role."
  default     = ["arn:aws:iam::aws:policy/PowerUserAccess"]
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
    attachmentContextIds = list(any)
  }))
  default = {}
}
