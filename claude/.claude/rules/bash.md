---
paths:
  - "**/*.sh"
  - "**/*.bash"
  - "**/.zshrc"
  - "**/.bashrc"
---

# Bash Standards

All scripts must start with `set -euo pipefail`.

Lint and format before committing:

```bash
shellcheck script.sh && shfmt -d script.sh
```

Format in place with `shfmt -i 2 -w script.sh`.
