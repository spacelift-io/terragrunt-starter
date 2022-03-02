terraform {
  source = "tfr:///spacelift-io/policy/spacelift?version=0.0.2"
}

inputs = {
    name = "(Example) DevOps are admins"
    body = file("./policy.rego")
    type = "LOGIN"
}
