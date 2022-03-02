terraform {
  source = "tfr:///spacelift-io/policy/spacelift?version=0.0.2"
}

inputs = {
    name = "(Example) All of Engineering gets read access"
    body = file("./policy.rego")
    type = "ACCESS"
}
