# Terragrunt Starter

The purpose of this repository is to help users get started with using Terragrunt + Spacelift.

## What does this repository create?
* 1 AWS IAM Role with `PowerUserAccess`
    * This is the role that will be assumed during `terragrunt` commands
* `n` Spacelift Stacks: The number of stacks created depends upon the `stacks` input variable in the `terragrunt.hcl` file in the root of this repository
    * 1 Spacelift AWS Credentials attachment per stack
        * This attaches the AWS IAM role to the stack
    * 2 Spacelift Stack Policy attachments per stack


## Steps
1) Create your own repository using this repository as a template. To do this, click **Use this template** button on this repository.

2) Next, you'll need to configure your new repository as a Spacelift stack. 

<!-- TODO -->