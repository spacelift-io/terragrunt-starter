package spacelift

# This example Git push policy ignores all changes that are outside a project's
# root. Other than that, it follows the defaults - pushes to the tracked branch
# trigger tracked runs, pushes to all other branches trigger proposed runs, tag
# pushes are ignored.
#
# You can read more about push policies here:
#
# https://docs.spacelift.io/concepts/policy/git-push-policy

track {
    affected
    input.push.branch == input.stack.branch
}

propose { affected }
ignore  { not affected }
ignore  { input.push.tag != "" }

# Here's a definition of an affected file - its path must:
#
# a) start with the Stack's project root, and;
# b) does not contain a /
# c) end with ".tf", indicating that it's a Terraform source file;
affected {
    filepath := input.push.affected_files[_]

    startswith(filepath, input.stack.project_root)
    not contains(filepath, "/")
    endswith(filepath, ".tf")
}

# OR

# a) start with the Stack's project root, and;
# b) does not contain a /
# c) end with ".hcl", indicating that it's a Terraform source file;
affected {
    filepath := input.push.affected_files[_]

    startswith(filepath, input.stack.project_root)
    not contains(filepath, "/")
    endswith(filepath, ".hcl")
}

# Learn more about sampling policy evaluations here:
#
# https://docs.spacelift.io/concepts/policy#sampling-policy-inputs
sample { true }