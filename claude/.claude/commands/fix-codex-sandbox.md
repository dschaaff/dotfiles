---
description: Re-apply the codex plugin's nested-Seatbelt patch after a plugin reinstall/upgrade
allowed-tools: Bash, Read, Edit
---

The `codex@openai-codex` plugin needs two things to work under Claude Code's local
macOS (Seatbelt) sandbox. Layer 2 lives in settings and persists; **layer 1 is a local
edit to the plugin cache and is silently lost on every plugin reinstall or upgrade.**
This command restores layer 1 and verifies layer 2.

## Step 1 — Locate the install and check both layers

```bash
P=$(jq -r '.. | objects | select(has("installPath")) | .installPath' ~/.claude/plugins/installed_plugins.json | rg 'openai-codex/codex' | head -1)
echo "install: ${P:-NOT FOUND}"
rg -c 'nestedSandboxUnavailable' "$P/scripts/codex-companion.mjs" 2>/dev/null || echo "LAYER 1 MISSING (patch needed)"
jq -e '.sandbox.excludedCommands | index("*codex-companion.mjs*")' ~/.claude/settings.json >/dev/null \
  && echo "LAYER 2 OK" || echo "LAYER 2 MISSING"
```

If layer 1 reports a count, the patch is already present — skip to Step 4.
If `$P` is empty, the plugin is not installed; stop and tell the user.

## Step 2 — Re-apply the nested-Seatbelt patch

Two edits to `$P/scripts/codex-companion.mjs`. All three anchors are unique in the
upstream file; if any fails to match, upstream changed — read the file and adapt
rather than forcing it.

**2a.** `spawnSync` is needed for the probe. Change the import:

```
import { spawn } from "node:child_process";
```
to:
```
import { spawn, spawnSync } from "node:child_process";
```

**2b.** Insert the probe helper immediately after the `REVIEW_SCHEMA` const
(`const REVIEW_SCHEMA = path.join(ROOT_DIR, "schemas", "review-output.schema.json");`):

```js
// nono/Claude-native-sandbox compatibility patch.
// macOS forbids applying a second Seatbelt profile from inside one already
// applied (`sandbox_apply: Operation not permitted`). When Codex runs inside an
// outer sandbox (nono, Claude Code's native sandbox), its own `read-only` /
// `workspace-write` modes — which shell out to `sandbox-exec` — fail silently.
// Probe once whether a nested sandbox can be applied; if not, fall back to
// `danger-full-access` (Codex's no-inner-sandbox mode). The outer sandbox still
// fully contains Codex, so nothing escapes that wasn't already permitted.
let nestedSandboxProbe = null;
function nestedSandboxUnavailable() {
  if (process.platform !== "darwin") {
    return false;
  }
  if (nestedSandboxProbe === null) {
    const result = spawnSync("sandbox-exec", ["-p", "(version 1)(allow default)", "true"], {
      stdio: "ignore"
    });
    // status !== 0 (or spawn error) means the nested Seatbelt apply was denied.
    nestedSandboxProbe = Boolean(result.error) || result.status !== 0;
  }
  return nestedSandboxProbe;
}

function resolveSandboxMode(preferred) {
  return nestedSandboxUnavailable() ? "danger-full-access" : preferred;
}
```

**2c.** Route the two task/adversarial-review call sites through it:

- `sandbox: "read-only",` → `sandbox: resolveSandboxMode("read-only"),`
- `sandbox: request.write ? "workspace-write" : "read-only",` → `sandbox: resolveSandboxMode(request.write ? "workspace-write" : "read-only"),`

Leave `scripts/lib/codex.mjs` alone. `runAppServerReview` hardcodes `read-only` and
bypasses this helper, so the native `/codex:review` path stays unpatched — that is a
known upstream limitation, not something to fix here.

## Step 3 — Restore layer 2 if missing

Only if Step 1 reported `LAYER 2 MISSING`. Add `"*codex-companion.mjs*"` to
`sandbox.excludedCommands` in `~/.claude/settings.json`, then validate with
`jq -e '.sandbox.excludedCommands' ~/.claude/settings.json`.

`codex*` alone is NOT enough: the matcher works on sub-command prefixes and the
plugin runs as `node ".../codex-companion.mjs"`. Without this, `codex app-server`
dies with `failed to initialize sqlite state runtime under ~/.codex` (exit 1),
because `~/.codex` and the plugin's job-log dir are both unwritable. A filesystem
`allowWrite` entry does not fix it — the built-in deny on `~/.claude/plugins`
overrides `~/.claude/plugins/data/`.

Note this edit may be refused by the auto-mode permission classifier as
self-modification. If so, show the user the exact change and let them apply it.

## Step 4 — Verify empirically

Run both paths. Use the literal full path, and do NOT add a `codex` substring
anywhere else in the command — `excludedCommands` matches it and would silently
unsandbox the whole call, producing a false pass.

```bash
timeout 240 node "$P/scripts/codex-companion.mjs" task --effort low \
  'Run exactly this and report exact output: touch ./_probe_ro && echo WROTE || echo BLOCKED' 2>&1 | tail -6
timeout 240 node "$P/scripts/codex-companion.mjs" task --write --effort low \
  'Run exactly this and report exact output: touch ./_probe_rw && echo WROTE || echo BLOCKED' 2>&1 | tail -6
```

Expected: read-only reports `BLOCKED`, `--write` reports `WROTE`. Anything else and
the patch is not effective. Clean up with `trash ./_probe_rw` (the read-only probe
creates no file).

Failure triage:
- `codex app-server exited unexpectedly (exit 1)` → layer 2 missing. The plugin
  swallows app-server stderr; spawn `codex app-server` directly with piped stdio to
  read the real error.
- `EPERM ... jobs/*.log` → layer 2 missing. `CLAUDE_PLUGIN_DATA=$TMPDIR/x` redirects
  plugin state to a writable dir so you can see past it while debugging.
- A passing `codex exec --sandbox read-only` proves nothing: the plugin uses the
  `app-server` JSON-RPC transport, not `exec`.

## Step 5 — Report

State which layers were missing, what you changed, and paste the two probe results.
