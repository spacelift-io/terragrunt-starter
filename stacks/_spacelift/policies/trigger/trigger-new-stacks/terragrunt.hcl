terraform {
  source = "tfr://spacelift.dev/spacelift-io/stack/spacelift?version=0.0.1"
}

inputs = {
    name = "Trigger newly created Spacelift stacks."
    body = file(./policy.rego)
    type = "TRIGGER"
}
