---
paths:
  - "**/*.tf"
  - "**/*.tfvars"
  - "**/*.tofu"
  - "**/.terraform.lock.hcl"
---

# Terraform / OpenTofu Standards

Always use opentofu over terraform.

| purpose             | tool   |
| ------------------- | ------ |
| lint terraform code | tflint |
| security checks     | tfsec  |

Commands that launch providers (`tofu init`, `plan`, `apply`, `refresh`, `import`, `state`) must run unsandboxed — the sandbox blocks provider plugin execution.
