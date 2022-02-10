package spacelift

trigger[stack.id] {
    change := input.run.changes[_]
    change.phase == "apply"
    change.entity.type == "spacelift_environment_variable"
    stack := input.stacks[_]
    sanitized(stack.id) == change.entity.data.values.stack_id
}

sample {
  true
}
