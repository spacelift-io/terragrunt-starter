variable "spacelift_account_name" {
  type        = string
  description = "The name of the Spacelift account you are using."
}

variable "repository_name" {
  type        = string
  description = "The name of the Git repository for this terragrunt-starter."
}

variable "repository_branch" {
  type        = string
  description = "The name of the branch to use for the specified Git repository."
}

variable "create_iam_role" {
  type        = bool
  description = "Whether or not to create an IAM Role that can be re-used by generated stacks."
  default     = true
}

variable "iam_role_policy_arns" {
  type        = list(string)
  description = "A list of managed policy ARNs to attach to the shared IAM Role."
  default     = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}

variable "stacks" {
  type = map(object({
    autodeploy             = bool,
    additional_labels      = list(string)
    depends_on_stacks      = list(string)
    terraform_version      = optional(string)
    enable_local_preview   = bool
    worker_pool_id         = optional(string)
    administrative         = bool
    description            = string
    create_own_iam_role    = bool
    setup_aws_integration  = bool
    execution_role_arn     = optional(string)
    attachment_policy_ids  = list(string)
    attachment_context_ids = list(any)
  }))
  default = {}
}
