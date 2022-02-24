terraform {
  source = "tfr://spacelift.dev/spacelift-io/policy/spacelift?version=0.0.1"
}

inputs = {
    name = "(Example) All of Engineering gets read access"
    body = file("./policy.rego")
    type = "ACCESS"
}
