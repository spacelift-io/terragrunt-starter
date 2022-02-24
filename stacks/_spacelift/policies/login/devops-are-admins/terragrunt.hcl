terraform {
  source = "tfr://spacelift.dev/spacelift-io/policy/spacelift?version=0.0.1"
}

inputs = {
    name = "(Example) DevOps are admins test"
    body = file("./policy.rego")
    type = "LOGIN"
}
