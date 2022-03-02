terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

// This is only needed here for the "aws_iam_role" that
// we need to create for the managed stacks in main.tf
// because IAM Roles are global, the region doesn't matter here
// (assuming no additional AWS resources are used/added in main.tf)
// 
// Feel free to change the implementation to how you'd like!
provider "aws" {
  region = "us-east-1"
}
