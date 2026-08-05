# Global Claude Standards

Global instructions for all projects. Project-specific CLAUDE.md files override these defaults.

- Use skills proactively when they match the task — suggest relevant ones, don't block on them

- Keep responses focused, brief, and concise. Keep disclaimers and caveats short, and spend most of the response on the main answer. When asked to explain something, give a high-level summary unless an in-depth explanation is specifically requested.

- Match the length of written documents (reports, markdown, summaries) to what the task needs: cover the substance, but don't pad with filler sections, redundant summaries, or boilerplate.

- Before your first tool call, say in one sentence what you're about to do. While working, give a brief update only when you find something important or change direction. When you finish, lead with the outcome — the first sentence answers "what happened," with supporting detail after it.

- Only correct an earlier statement when the error would change my code, conclusions, or decisions. State corrections plainly and briefly, then continue. For slips that change nothing, make the fix and move on.

- Delegate to subagents liberally to keep my main context clean. Investigations that read many files, broad searches, and independent parallel tracks should go to subagents that return conclusions rather than file dumps. Prefer one well-scoped subagent over several overlapping ones. Don't spawn a subagent purely to double-check work you've already done.

## Philosophy

- **No speculative features** - Don't add features, flags, or configuration unless users actively need them
- **No premature abstraction** - Don't create utilities until you've written the same code three times
- **Clarity over cleverness** - Prefer explicit, readable code over dense one-liners
- **Justify new dependencies** - Each dependency is attack surface and maintenance burden
- **No phantom features** - Don't document or validate features that aren't implemented
- **Replace, don't deprecate** - When a new implementation replaces an old one, remove the old one entirely. No backward-compatible shims, dual config formats, or migration paths. Proactively flag dead code — it adds maintenance burden and misleads both developers and LLMs.
- **Verify at every level** - Set up automated guardrails (linters, type checkers, pre-commit hooks, tests) as the first step, not an afterthought. Prefer structure-aware tools (ast-grep, LSPs, compilers) over text pattern matching — they catch what text search misses.
- **Bias toward action** - Decide and move on minor choices (naming, formatting, defaults, picking among equivalents) and anything easily reversed; state your assumption so the reasoning is visible. Ask first only for scope changes, destructive/write operations on external services, or commitments to interfaces, data models, or architecture. When the task is done, stop cleanly — no "Want me to also…?".
- **Deliver the requested scope** - Finish the whole task: no stubs, placeholders, or TODOs standing in for work. Deliver at the scope intended — don't quietly narrow, widen, or transform it. If something adjacent is broken or a better approach exists, say so in a sentence and continue with the task as asked. Stop short of actions clearly beyond what was requested; adjacent cleanup and refactors are separate work.
- **Agent-native by default** - Design so agents can achieve any outcome users can. Tools are atomic primitives; features are outcomes described in prompts. Prefer file-based state for transparency and portability. When adding UI capability, ask: can an agent achieve this outcome too?

## Code Quality

### Hard limits

1. ≤100 lines/function, cyclomatic complexity ≤8
2. ≤5 positional params
3. 100-char line length
4. No deep relative imports (`../../`). Python/Rust: absolute imports. TS/Node ESM: relative (`./`) or project-configured path aliases
5. Google-style docstrings on non-trivial public APIs

### Zero warnings policy

Fix every warning from every tool — linters, type checkers, compilers, tests. If a warning truly can't be fixed, add an inline ignore with a justification comment. Never leave warnings unaddressed; a clean output is the baseline, not the goal.

### Comments

Code should be self-documenting. No commented-out code—delete it. If you need a comment to explain WHAT the code does, refactor the code instead.

### Error handling

- Fail fast with clear, actionable messages
- Never swallow exceptions silently
- Include context (what operation, what input, suggested fix)

### Reviewing code

Evaluate in order: architecture → code quality → tests → performance.

Report everything you find in one pass — don't pre-filter by severity, and don't stop mid-review to ask. For each issue: describe it concretely with file:line references, present options with trade-offs when the fix isn't obvious, and recommend one. Filtering and applying fixes is a separate step after the full report.

### Testing

**Test behavior, not implementation.** Tests should verify what code does, not how. If a refactor breaks your tests but not your code, the tests were wrong.

**Test edges and errors, not just the happy path.** Empty inputs, boundaries, malformed data, missing files, network failures — bugs live in edges. Every error path the code handles should have a test that triggers it.

**Mock boundaries, not logic.** Only mock things that are slow (network, filesystem), non-deterministic (time, randomness), or external services you don't control.

**Verify tests catch failures.** Break the code, confirm the test fails, then fix. Use mutation testing (`cargo-mutants`, `mutmut`) to verify systematically. Use property-based testing (`proptest`, `hypothesis`) for parsers, serialization, and algorithms.

## Development

When adding dependencies, CI actions, or tool versions, always look up the current stable version — never assume from memory unless the user provides one.

### GitLab

Use the glab cli to interact with GitLab.

### CLI tools

| tool           | replaces   | usage                                                                     |
| -------------- | ---------- | ------------------------------------------------------------------------- |
| `rg` (ripgrep) | grep       | `rg "pattern"` - 10x faster regex search                                  |
| `fd`           | find       | `fd "*.py"` - fast file finder                                            |
| `ast-grep`     | -          | `ast-grep --pattern '$FUNC($$$)' --lang py` - AST-based code search       |
| `shellcheck`   | -          | `shellcheck script.sh` - shell script linter                              |
| `shfmt`        | -          | `shfmt -i 2 -w script.sh` - shell formatter                               |
| `actionlint`   | -          | `actionlint .github/workflows/` - GitHub Actions linter                   |
| `zizmor`       | -          | `zizmor .github/workflows/` - Actions security audit                      |
| `prek`         | pre-commit | `prek run` - fast git hooks (Rust, no Python)                             |
| `trash`        | rm         | `trash file` - moves to macOS Trash (recoverable). **Never use `rm -rf`** |

Prefer ast-grep over ripgrep when searching for code structure (function calls, class definitions, imports, pattern matching across arguments). Use ripgrep for literal strings and log messages.

### Language standards

Full standards live in `~/.claude/rules/` and load when you touch matching files. Headlines:

- **Python** — `uv` + `ruff` + `ty`, latest stable, tests in `tests/`
- **Node/TS** — `bun` + `oxlint` + `oxfmt`, ESM only, strict tsconfig
- **Rust** — invoke the `rust-standards` skill
- **Bash** — `set -euo pipefail`, shellcheck + shfmt
- **Terraform** — opentofu, never terraform; tflint + tfsec
- **GitHub Actions** — SHA-pinned, zizmor-scanned

## Container Images

Always prefer ECR public, GitHub container registry, and quay.io over Docker Hub due to Docker Hub's rate limits.

## Workflow

**Before committing:**

1. Re-read your changes for unnecessary complexity, redundant code, and unclear naming
2. Run relevant tests — not the full suite
3. Run linters and type checker — fix everything before committing

**Commits:**

- Imperative mood, ≤72 char subject line, one logical change per commit
- Never amend/rebase commits already pushed to shared branches
- Never push directly to main — use feature branches and PRs
- Never commit secrets, API keys, or credentials — use `.env` files (gitignored) and environment variables

**Hooks and worktrees:**

- Install prek in every repo (`prek install`). Run `prek run` before committing. Configure auto-updates: `prek auto-update --cooldown-days 7`
- Parallel subagents require worktrees. Each subagent works in its own worktree (`git worktree add ../<name> <branch>`, or the Agent tool's `isolation: "worktree"`), never the main repo. Never share working directories.

**Pull requests:**
Describe what the code does now — not discarded approaches, prior iterations, or alternatives. Only describe what's in the diff.

Use plain, factual language. A bug fix is a bug fix, not a "critical stability improvement." Avoid: critical, crucial, essential, significant, comprehensive, robust, elegant.
