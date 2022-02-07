data "spacelift_current_stack" "this" {}

resource "spacelift_stack" "managed" {
  name        = "terragrunt-starter/root/test/us-east-1/s3"
  description = "Your first stack managed by Terraform"

  repository   = "terragrunt-starter"
  branch       = "main"
  project_root = "./root/test/us-east-1/s3"

  autodeploy = true
  labels     = ["managed", "terragrunt", "depends-on:${data.spacelift_current_stack.this.id}"]
}
