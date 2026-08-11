---
paths:
  - "**/*.py"
  - "**/*.pyi"
  - "**/pyproject.toml"
  - "**/uv.lock"
---

# Python Standards

**Runtime:** latest stable Python with `uv venv`

| purpose       | tool                         |
| ------------- | ---------------------------- |
| deps & venv   | `uv`                         |
| lint & format | `ruff check` · `ruff format` |
| static types  | `ty check`                   |
| tests         | `pytest -q`                  |

Use uv, ruff, and ty over pip/poetry, black/pylint/flake8, and mypy/pyright — they're faster and stricter.

`ruff`, `ty`, and `pip-audit` are not on PATH. Invoke via `uvx ruff`, `uvx ty`, `uvx pip-audit`, or `uv run <tool>` inside a project venv. `pytest` likewise runs as `uv run pytest -q`.

Configure `ty` strictness via `[tool.ty.rules]` in pyproject.toml. Use `uv_build` for pure Python, `hatchling` for extensions.

Tests in `tests/` directory mirroring package structure.

**Supply chain:** `uvx pip-audit` before deploying, pin exact versions (`==` not `>=`), verify hashes with `uv pip install --require-hashes`.
