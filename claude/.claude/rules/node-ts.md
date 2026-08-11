---
paths:
  - "**/*.{ts,tsx,mts,cts}"
  - "**/*.{js,jsx,mjs,cjs}"
  - "**/package.json"
  - "**/tsconfig*.json"
  - "**/bunfig.toml"
---

# Node/TypeScript Standards

**Runtime:** latest Node LTS, ESM only (`"type": "module"`)

| purpose   | tool           |
| --------- | -------------- |
| deps & pm | `bun`          |
| lint      | `oxlint`       |
| format    | `oxfmt`        |
| test      | `bun test`     |
| types     | `tsc --noEmit` |

Use bun as the package manager and test runner (`bun install`, `bun add`, `bun run`, `bun test`) — no vitest. Note `bun test` executes on the Bun runtime; if production runs on Node, that's a known test/prod runtime gap to weigh per project.

Use oxlint and oxfmt over eslint/prettier — they're faster and stricter. Enable `typescript`, `import`, `unicorn` plugins.

`oxlint` is not on PATH — invoke via `bunx oxlint`. `oxfmt` is on PATH. `tsc` is not global; run `bunx tsc --noEmit` or use the project's local install.

**tsconfig.json strictness** — enable all of these:

```jsonc
"strict": true,
"noUncheckedIndexedAccess": true,
"exactOptionalPropertyTypes": true,
"noImplicitOverride": true,
"noPropertyAccessFromIndexSignature": true,
"verbatimModuleSyntax": true,
"isolatedModules": true
```

Colocated `*.test.ts` files, run with `bun test`.

**Supply chain:** `bun audit --audit-level=moderate` before installing, pin exact versions with `bun add -E` (no `^` or `~`), enforce a 24-hour publish delay (`bun install --minimum-release-age=86400`, seconds — or set `minimumReleaseAge` in `bunfig.toml`). Bun blocks dependency lifecycle scripts by default; allow specific packages via `trustedDependencies` only when needed.
