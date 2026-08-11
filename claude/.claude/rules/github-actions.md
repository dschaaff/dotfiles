---
paths:
  - ".github/workflows/**"
  - ".github/actions/**"
  - "**/action.{yml,yaml}"
---

# GitHub Actions Standards

Pin actions to SHA hashes with version comments: `actions/checkout@<full-sha>  # vX.Y.Z` (use `persist-credentials: false`).

Lint with `actionlint .github/workflows/` and scan with `zizmor .github/workflows/` before committing.

Configure Dependabot with 7-day cooldowns and grouped updates. Use the `uv` ecosystem (not `pip`) for Python projects so Dependabot updates `uv.lock`.
