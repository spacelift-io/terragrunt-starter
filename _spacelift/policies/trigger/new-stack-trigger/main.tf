resource "spacelift_policy" "no-weekend-deploys" {
  name = "Trigger newly created Spacelift stacks"
  body = file("./policy.rego")
  type = var.type
}
