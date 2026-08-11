# Back to stow

## Problem

The dotfiles repo moved from GNU Stow to chezmoi on 2026-06-18. The chezmoi workflow does
not fit how the files actually get edited. Every change made in `$HOME` — by an app, by
Claude Code, or by hand — has to be pushed back into the source tree with `chezmoi re-add`
before it is tracked. Six files have already drifted out of sync because that step was
missed. Editing a config means either editing the source and applying, or editing the live
file and remembering to re-add. The source filenames are also mangled by chezmoi's
attribute prefixes (`dot_`, `private_`, `executable_`, `create_`), so the repo no longer
looks like the thing it deploys, and two files are Go templates that cannot be read as
config.

Stow has none of this. A symlink means the live file *is* the repo file. There is no apply
step, no re-add step, and no drift.

## Solution

`~/.dotfiles` is a GNU Stow package tree again. Every managed path in `$HOME` is a symlink
that resolves into the repo, so editing the live file edits the repo directly and `git
status` is the only drift report needed. Every content change made during the chezmoi era
is carried forward. One command — `./install.sh` — links or relinks everything. chezmoi is
removed from the machine.

## Design decisions

### Branch and merge strategy

Work happens as commits on `back-to-stow`. Master's tip is the merge base of the two
branches, so `back-to-stow` already contains all of master and the final integration is a
fast-forward with no merge commit. The chezmoi-era layout stays reachable through this
branch's ancestor commits, which is the rollback path of last resort.

### Package layout

One top-level directory per package, containing the path relative to `$HOME`. Twenty-nine
packages. The 27 that existed on master keep their names and shapes. Two are new, for
content that only ever existed under chezmoi: `agents` and `nono`. `alacritty` and
`ideavim` stay deleted — that was a deliberate call during the chezmoi era, not an
accident of the layout change.

Every top-level directory is a package, which is what lets `install.sh` use a bare `*/`
glob with no list to maintain. Non-package files stay at the repo root as plain files
(`README.md`, `install.sh`, `brewfile`, `.gitignore`), where the glob cannot pick them up.

### Directory folding

Stow replaces a whole directory with a single symlink only when that directory does not
exist in the target at install time. If it already exists as a real directory, stow
descends into it and creates one symlink per entry. A real *file* sitting where stow wants
to place a symlink is neither folded nor descended into — it is a conflict, and stow
refuses.

Default folding is kept — it is what master did, and it is the property that makes new
files self-tracking: a rule written into `~/.claude/rules/` or a skill written into
`~/.agents/skills/` is in the repo the moment it is created.

Because folding hinges on the directory being absent, the cutover has to *remove* the live
directories it wants folded before installing. That is also why `stow --adopt` is not the
mechanism here: adopt moves each conflicting file into the package and links it back
individually, and since it leaves the target directories in place, nothing folds on that
run. Adopt-then-`--restow` would eventually fold, because restow unstows first and stow
removes directories it has emptied — but that is a longer path to the same place, and it
mutates package contents before the drift has been reviewed. The chosen order reviews
drift first, then moves live files aside in one reversible step.

Two directories fold only after unmanaged leftovers are cleared: `~/.agents` (blocked by
`skills/writing-as-dschaaff-workspace/`, leftover skill-tuning eval output, and by
`skills/.claude/.cc-writes/`, a Claude Code scratch directory) and `~/.config/zellij`
(blocked by `config.kdl.bak`). Those leftovers are discarded. `.cc-writes` will be
recreated inside the folded tree, so `.gitignore` covers it.

Directories that stay unfolded because an application keeps its own state alongside repo
files: `~/.claude`, `~/.config`, `~/Library`, `~/Library/Application Support`,
`~/Library/Application Support/lazygit`, `~/.config/karabiner`, `~/.config/nono`,
`~/.config/nono/profiles`, `~/.config/nvim`, `~/.config/nvim/spell`, `~/.config/opencode`,
`~/.config/zed`, `~/.tmux`, `~/bin`.

`~/.claude` is the one case where accidental folding would be harmful rather than merely
surprising: on a machine where it does not yet exist, stow would fold it, and Claude Code
would then write `.credentials.json`, `history.jsonl`, `projects/`, and `sessions/` inside
the repo. `install.sh` therefore pre-creates that one directory, and `.gitignore` covers
those paths as a second layer.

### Stow's default ignore list silently drops files

Stow ignores a built-in list of patterns unless a package supplies
`.stow-local-ignore`, which *replaces* the list wholesale rather than adding to it. The
built-in list — read from `Stow.pm` in stow 2.4.1 — is `RCS`, `.+,v`, `CVS`, `\.\#.+`,
`\.cvsignore`, `\.svn`, `_darcs`, `\.hg`, `\.git`, `\.gitignore`, `\.gitmodules`, `.+~`,
`\#.*\#`, `^/README.*`, `^/LICENSE.*`, and `^/COPYING`.

Exactly one tracked file in the post-migration tree is caught by it:
`neovim/.config/nvim/.gitignore`. Without intervention stow would skip it in silence, and
the cutover — which deletes the live copy first — would destroy it. Master avoided this by
carrying a `neovim/.stow-local-ignore`; that file is restored, and it must not list
`\.gitignore`. Stow always appends `^/.stow-local-ignore$` to whatever list it compiles,
so the file never deploys itself.

Reasoning about which regexes match which filenames is exactly the kind of check that
should not rest on reasoning. Slice 5 installs the whole tree into an empty temporary
target and compares the resulting manifest against the expected one, which catches this
class of omission by observation instead.

### Translating chezmoi's source attributes

| chezmoi source form | stow form |
| --- | --- |
| `dot_zshrc` | `zsh/.zshrc` |
| `private_karabiner.json` | prefix dropped |
| `executable_tmux-sessionizer` | prefix dropped; git mode set to `100755` |
| `create_nvim-pack-lock.json` | plain tracked file |
| `symlink_skills.tmpl` | a real symlink committed in the repo |
| `dot_gitconfig.tmpl` | plain config file with literal values |

Two behavior changes follow and are accepted. Files that carried `private_` no longer get
mode `0600`: git records only the executable bit, so their mode after checkout is whatever
the umask yields (`644` under the default `022`) and cannot be pinned from the repo. None
of those files holds a credential. And the nvim plugin lockfile becomes a symlink that
`vim.pack` writes through, so lockfile updates appear directly as repo diffs; this is how
it behaved during the stow era, and chezmoi's `create_` attribute existed only to stop
`apply` from clobbering it — which is also why that file is one of the six drifts.

### Git identity in plaintext

`.gitconfig` and `.workGitConfig` were the only templates carrying real data: personal
email, work email, and an SSH signing public key. They become plain files with those
values written literally, which is what master had. All three values are already in this
repo's history from the stow era, and an SSH *public* key is not a secret. The rejected
alternative — keeping `[user]` in an untracked `~/.gitconfig.local` — buys nothing here,
because the values are already published in history, and it adds a hand-written
per-machine file that version control cannot restore.

The live `~/.gitconfig` and `~/.workGitConfig` are chezmoi's own rendered output, so they
are the reference for checking the de-templated files rather than something to be
reconciled as drift.

### The `~/.claude/skills` pointer

Skills live in `~/.agents/skills` so that Claude Code, Codex, and opencode can all reach
them, and `~/.claude/skills` is a pointer at that directory. Under chezmoi this was a
templated symlink. Under stow it is a symlink committed in the repo with the **relative**
target `../../agents/.agents/skills`.

An absolute target is not an option: stow 2.4.1 refuses to stow an absolute symlink found
inside a package, and it does not merely skip the file — it registers a conflict and aborts
every operation, all 29 packages included. Measured against a throwaway `$HOME`,
`install.sh` planned 43 links, hit `source is an absolute symlink`, printed `All operations
aborted`, exited 1, and created nothing. The relevant guard is in `Stow.pm` around line 503,
commented "Don't try to stow absolute symlinks (they can't be unstowed)". No flag overrides
it.

The relative target resolves from the symlink's own directory, `<repo>/claude/.claude/`, so
`../../agents/.agents/skills` lands on `<repo>/agents/.agents/skills` — inside the repo,
independent of where the repo sits. `~/.claude/skills` therefore resolves in two hops:
`$HOME` link → repo symlink → the repo's own `agents` package. Since `~/.agents` folds to
that same directory, both paths reach one place.

One visible side effect: because the link now points inside the repo, Claude Code indexes
`claude/.claude/skills` as a directory-scoped skill set while working in this repo, showing
each skill twice — once scoped, once global. That is cosmetic. Having `install.sh` create
`~/.claude/skills` imperatively would avoid it, at the cost of a special case in a script
whose whole appeal is that it has none.

### Inventory reconciliation

A one-directional audit driven by `git ls-files` cannot find a path that is live and
managed but absent from the repo, which is the difference that would cause data loss. The
two inventories have been reconciled in both directions against `chezmoi managed --include
files,symlinks`: all 118 managed leaves map onto the package table below, and nothing is
managed-but-untracked. The snapshot is still taken in slice 1 and compared in slice 4,
because it costs one command and the alternative is trusting a result measured before the
work started.

### Ignore rules

`.gitignore` is rewritten from `.chezmoiignore`, which is a cleaner and more complete list
than master's `.gitignore` (that one had duplicated `.gitignore` entries and a stray
`warp`). Paths become package-relative.

The list deliberately covers application-writable paths inside *every* managed directory,
not just the ones that fold today. Fold state is not permanent: `stow --restow` unstows
before it stows, so a directory that stops holding unmanaged files becomes foldable on the
next run, and an app that writes there would then be writing into the repo. Guarding up
front is cheaper than discovering it through a surprise commit.

## Testing

This repo has no test framework and does not need one — it holds configuration, not code.
Verification is by command, and every slice below names the command that proves it. There
is no prior art to follow; the previous spec in this directory (`2026-08-10-sdd-skills.md`)
verified skills by invoking them, which has no analogue here.

Four seams, chosen because each one fails in a way the others cannot see:

1. **Manifest completeness** (slice 5). Install into an empty temporary target and check
   that every expected target path appears. This is the only check that catches a file
   stow ignores rather than deploys, and it runs before anything in `$HOME` is touched.
   A dry run against `$HOME` cannot substitute: it reports conflicts, and a silently
   ignored file produces no conflict.
2. **Link identity** (slice 6). For each expected target, `realpath` must equal `realpath`
   of its package source exactly, and `cmp -s` must confirm the content. Checking only
   that the resolved path *starts with* the repo directory would accept a link aimed at
   the wrong file in the right repo.
3. **Content equivalence** (slices 2 and 4). The de-templated git configs are diffed
   against chezmoi's rendered output; the six drifts are resolved against the live files.
   Symlinks can be correct while content is wrong.
4. **The configs still load** (slice 6). Smoke tests exercise the tools that read the
   files. These catch a lost executable bit or a mangled config, but they are not topology
   evidence — `nvim --headless +q` passes with `~/.config/nvim/.gitignore` missing.

## Slices

### Slice 1: Inventory snapshot and stow package tree — DONE

**Goal:** Capture the pre-migration inventory, then restructure the source tree into 29
stow packages with chezmoi's filename attributes stripped, changing no file content.

First, while chezmoi still understands the source tree, snapshot the inventory outside the
repo — the restructure destroys chezmoi's ability to produce it:

```
mkdir -p ~/.dotfiles-migration
chezmoi managed --include files,symlinks > ~/.dotfiles-migration/chezmoi-managed.txt
```

Expect 118 lines. Slice 4 compares against this file.

Use `git mv` throughout so history follows the files. The spec file you are reading already
sits at its post-migration path; move the rest of `dot_agents/` in beside it.

Package → source mapping, complete:

| Package | Source | Deploys to |
| --- | --- | --- |
| `agents` | `dot_agents/**` | `~/.agents/**` |
| `atuin` | `dot_config/atuin/**` | `~/.config/atuin/**` |
| `bat` | `dot_config/bat/**` | `~/.config/bat/**` |
| `bin` | `bin/executable_{ctrl_t.sh,tmux-sessionizer,tty-copy}` | `~/bin/*` |
| `claude` | `dot_claude/**` | `~/.claude/**` |
| `ghostty` | `dot_config/ghostty/**` | `~/.config/ghostty/**` |
| `git` | `dot_gitconfig.tmpl`, `dot_workGitConfig.tmpl`, `dot_gitcommittemplate.txt` | `~/.gitconfig`, `~/.workGitConfig`, `~/.gitcommittemplate.txt` |
| `goneovim` | `dot_config/goneovim/**` | `~/.config/goneovim/**` |
| `iterm2` | `com.googlecode.iterm2.plist` | `~/com.googlecode.iterm2.plist` |
| `k9s` | `dot_config/k9s/skin.yml` | `~/.config/k9s/skin.yml` |
| `karabiner` | `dot_config/private_karabiner/**` | `~/.config/karabiner/**` |
| `lazygit` | `private_Library/private_Application Support/lazygit/config.yml` | `~/Library/Application Support/lazygit/config.yml` |
| `markdownlint` | `dot_markdownlintrc` | `~/.markdownlintrc` |
| `neovim` | `dot_config/nvim/**` | `~/.config/nvim/**` |
| `nono` | `dot_config/nono/**` | `~/.config/nono/**` |
| `opencode` | `dot_config/opencode/**` | `~/.config/opencode/**` |
| `ripgrep` | `dot_config/ripgrep/**` | `~/.config/ripgrep/**` |
| `starship` | `dot_config/starship.toml` | `~/.config/starship.toml` |
| `terraform` | `dot_terraformrc` | `~/.terraformrc` |
| `tfswitch` | `dot_tfswitch.toml` | `~/.tfswitch.toml` |
| `tmux` | `dot_tmux.conf`, `dot_tmux/themes/**` | `~/.tmux.conf`, `~/.tmux/themes/**` |
| `vale` | `dot_vale.ini` | `~/.vale.ini` |
| `vim` | `dot_vimrc`, `dot_gvimrc`, `dot_vim/**` | `~/.vimrc`, `~/.gvimrc`, `~/.vim/**` |
| `wezterm` | `dot_wezterm.lua`, `executable_wezterm.sh` | `~/.wezterm.lua`, `~/wezterm.sh` |
| `yamllint` | `dot_config/yamllint/**` | `~/.config/yamllint/**` |
| `zed` | `dot_config/zed/**` | `~/.config/zed/**` |
| `zellij` | `dot_config/zellij/config.kdl` | `~/.config/zellij/config.kdl` |
| `zsh` | `dot_zshrc`, `dot_zsh_plugins.txt`, `dot_p10k.zsh`, `dot_atuin.zsh`, `dot_zshfn/**` | `~/.zshrc`, `~/.zsh_plugins.txt`, `~/.p10k.zsh`, `~/.atuin.zsh`, `~/.zshfn/**` |
| `zsh-patina` | `dot_config/zsh-patina/**` | `~/.config/zsh-patina/**` |

Prefix rules applied at every path segment: `dot_` → `.`; `private_`, `create_`,
`executable_` → dropped. The `.tmpl` suffix is dropped from the two git files and from
`dot_claude/symlink_skills.tmpl`, which becomes `claude/.claude/skills` — leave it as a
regular file in this slice; slice 2 turns it into a symlink. Note that prefixes nest:
`dot_config/private_karabiner/assets/private_complex_modifications/custom-capslock.json`
becomes `karabiner/.config/karabiner/assets/complex_modifications/custom-capslock.json`.

Also in this slice, add the two files chosen for tracking that chezmoi never managed. Copy
them from `$HOME`, do not move them; the cutover removes the originals.

- `~/.agents/skills/playwright-cli/` → `agents/.agents/skills/playwright-cli/`
- `~/.config/nono/profiles/my-opencode.jsonc` → `nono/.config/nono/profiles/my-opencode.jsonc`

**Done when:** `~/.dotfiles-migration/chezmoi-managed.txt` holds 118 lines; every tracked
file sits under one of the 29 package directories above, except the root files `README.md`,
`.gitignore`, `.chezmoiignore`, and `.chezmoi.toml.tmpl`; and the derived target manifest
matches the pre-migration one. Derive it by stripping the leading package component from
each `git ls-files` path and compare as a set against `chezmoi-managed.txt`. Expect 128
derived targets against 118 managed ones, with no managed target missing and exactly ten
repo-only additions permitted:

- `.agents/docs/specs/2026-08-11-back-to-stow.md` — this spec, written after chezmoi stopped
  being the source of truth
- `.agents/skills/playwright-cli/SKILL.md` and its seven files under `references/`
- `.config/nono/profiles/my-opencode.jsonc`

`.agents/docs/specs/2026-08-10-sdd-skills.md` is *not* in that set — chezmoi did manage it,
so it appears in both inventories. It is absent from `$HOME`, which slice 4 covers.

A name-only check that no path still contains `dot_`, `private_`, `executable_`, or
`create_` is not sufficient — it proves nothing about where files landed.

### Slice 2: Content and mode translation — DONE

**Goal:** Turn the three files that chezmoi handled specially into plain files stow can
deploy, and restore executable bits.

De-template `git/.gitconfig`, replacing exactly three interpolations with literals:

- `{{ .personalEmail }}` → `daniel@danielschaaff.com`
- `{{ .signingKey }}` → `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2yLApsXhRdeElX86Zy1kt+n1cEVepMRLlF+LWE40l7`
- `{{ .chezmoi.homeDir }}/.gitignore_global` → `~/.gitignore_global`

De-template `git/.workGitConfig`, replacing two:

- `{{ .workEmail }}` → `dschaaff@cordial.com`
- `{{ .signingKey }}` → the same `ssh-ed25519` value as above

Both `[includeIf]` blocks in `git/.gitconfig` must read `path = ~/.workGitConfig` with a
capital `C`. Master had `~/.workGitconfig`, which worked only because APFS is
case-insensitive by default; the chezmoi branch fixed it and the fix is kept.

Replace `claude/.claude/skills` with a symlink whose target is the literal relative path
`../../agents/.agents/skills`. It must not be absolute — stow aborts every package when it
finds an absolute symlink inside one.

Set git mode `100755` on exactly these six files, using `chmod +x <file>` followed by `git
update-index --chmod=+x <file>` so the bit is recorded in the index and not only on disk:

- `bin/bin/ctrl_t.sh`
- `bin/bin/tmux-sessionizer`
- `bin/bin/tty-copy`
- `wezterm/wezterm.sh`
- `zsh/.zshfn/cleanup_handler_zsh.sh`
- `zsh/.zshfn/kpc`

Every other file in `zsh/.zshfn/` is a zsh autoload function and stays non-executable.

**Done when:** `rg -l --hidden '\{\{' git/` returns nothing — `--hidden` is required, since both
files are dotfiles and ripgrep skips them by default, making the check vacuous without it;
`diff git/.gitconfig ~/.gitconfig`
reports exactly one differing line, the `excludesfile` line, and `diff git/.workGitConfig
~/.workGitConfig` reports no differences — the live files are chezmoi's rendered output, so
anything else means a value was mistyped; `git config --file git/.gitconfig --get
user.email` prints `daniel@danielschaaff.com` and `--get includeIf.gitdir:~/development/work/.path`
prints `~/.workGitConfig`; `git ls-files -s` shows mode `120000` for
`claude/.claude/skills` and mode `100755` for exactly the six files above and no others.

### Slice 3: Repo meta — DONE

**Goal:** Remove chezmoi from the repo and add the stow entry points.

Delete `.chezmoi.toml.tmpl` and `.chezmoiignore`.

Restore `brewfile` from master at the repo root: `git checkout master -- brewfile`. It was
deleted as collateral damage in commit `d39b8be` ("Remove stow layout and switch README to
chezmoi") and is where `brew "stow"` is declared.

Add `neovim/.stow-local-ignore` so stow stops ignoring the tracked
`neovim/.config/nvim/.gitignore`. It replaces stow's built-in list for this package, so it
must reproduce the useful patterns while omitting `\.gitignore`:

```
# Replaces stow's built-in ignore list for this package. Omits \.gitignore so that
# .config/nvim/.gitignore actually deploys; stow would otherwise skip it silently.
\.git
\.gitmodules
\.hg
\.svn
.+~
\#.*\#
^/README.*
^/LICENSE.*
^/COPYING
```

Add `install.sh` at the repo root, mode `755`, with exactly this content:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# ~/.claude holds credentials and session state. Pre-create it so stow never folds the
# whole directory into a single symlink pointing into this repo.
mkdir -p "$HOME/.claude"

# Every top-level dir is a stow package. The glob must stay bare: stow consumes `--` and
# then reports no packages, and it rejects package names containing a slash, so neither
# `-- */` nor `./*/` works.
# shellcheck disable=SC2035
stow --restow --target="$HOME" --verbose "$@" */
```

It must pass `shellcheck` and `shfmt -i 2 -d` clean. The inline disable is load-bearing and
was measured, not assumed: shellcheck's SC2035 wants `-- */` or `./*/`, and stow rejects
both — `--` leaves it with no packages, and any package name containing a slash is an
error. A trailing slash alone is fine, which is why the bare glob works.

Rewrite `.gitignore` with package-relative paths. Required entries:

```
.DS_Store
*.bak

agents/.agents/skills/.claude

bin/bin/docker
bin/bin/docker-buildx
bin/bin/docker-compose
bin/bin/docker-credential-osxkeychain
bin/bin/kubectl
bin/bin/linkerd
bin/bin/orb
bin/bin/orbctl
bin/bin/release-cli
bin/bin/terraform
bin/bin/tofu
bin/bin/warp

claude/.claude/.claude.json
claude/.claude/.credentials.json
claude/.claude/backups
claude/.claude/history.jsonl
claude/.claude/projects
claude/.claude/sessions
claude/.claude/settings.local.json
claude/.claude/shell-snapshots
claude/.claude/statsig

k9s/.config/k9s/config.yml

karabiner/.config/karabiner/automatic_backups

lazygit/Library/Application Support/lazygit/development.log
lazygit/Library/Application Support/lazygit/github_pull_requests.json
lazygit/Library/Application Support/lazygit/state.yml

neovim/.config/nvim/.claude/settings.local.json
neovim/.config/nvim/.luarc.json
neovim/.config/nvim/nvim.log
neovim/.config/nvim/spell/en.utf-8.add.spl

nono/.config/nono/nono-profile.schema.json
nono/.config/nono/pack-update-hints.json
nono/.config/nono/packages
nono/.config/nono/profile-drafts
nono/.config/nono/profiles/.claude
nono/.config/nono/profiles/.probe

opencode/.config/opencode/.gitignore
opencode/.config/opencode/agent
opencode/.config/opencode/bun.lock
opencode/.config/opencode/cli.json
opencode/.config/opencode/node_modules
opencode/.config/opencode/package-lock.json
opencode/.config/opencode/package.json
opencode/.config/opencode/plugins
opencode/.config/opencode/service.json
opencode/.config/opencode/skills

tmux/.tmux/plugins

vim/.vim/plugged

zed/.config/zed/conversations
zed/.config/zed/prompts
zed/.config/zed/settings_backup.json
zed/.config/zed/themes

zsh/.cordial.sh
```

The nine `claude/.claude/*` runtime entries are the security-relevant ones: they only take
effect if `~/.claude` ever folds, which `install.sh` now prevents, and they exist so that a
failure of that guard cannot put credentials or session history under version control.

`zsh/.cordial.sh` is intentional even though no such file exists in the package today.
`~/.cordial.sh` holds work secrets and stays a plain untracked file in `$HOME`; the entry
guards against the master-era pattern of parking it inside the package directory, where it
would otherwise be committed.

Rewrite `README.md` to document: `brew install stow`, `git clone` to `~/.dotfiles`,
`./install.sh`, the dry-run (`./install.sh -n`) and unlink (`./install.sh -D`) forms, the
fact that every top-level directory is a package, that editing the live file in `$HOME`
edits the repo, that tpm must be cloned by hand into `~/.tmux/plugins/tpm` because it is
not tracked, and a warning that adding a file whose name stow's built-in ignore list
matches — anything named `.gitignore`, `.gitmodules`, or ending in `~` — needs a
`.stow-local-ignore` in that package or it will not deploy. Keep the existing macOS ulimit
section.

In `claude/.claude/settings.json`, remove these five permission entries and replace them
with `"Bash(stow *)"`:

```
"Bash(chezmoi diff *)"
"Bash(chezmoi managed *)"
"Bash(chezmoi cat *)"
"Bash(chezmoi verify *)"
"Bash(chezmoi source-path *)"
```

In `agents/.agents/docs/specs/2026-08-10-sdd-skills.md`, correct all four stale references
and nothing else — it is a completed spec:

- the skill-location path becomes `~/.dotfiles/agents/.agents/skills/<name>/SKILL.md`, and
  the `(chezmoi-managed)` parenthetical on that same line becomes `(stow-managed)`
- the Solution section's `~/.dotfiles/dot_agents/skills/` becomes
  `~/.dotfiles/agents/.agents/skills/`
- the two phrases describing a file as the "chezmoi source" for `~/.claude/CLAUDE.md` name
  `claude/.claude/CLAUDE.md` as the stow source instead

**Done when:** `git grep -il chezmoi` returns only this spec file — scope the search to
tracked files, since a plain `rg -i chezmoi` also matches `.git/config` and the reflogs;
`shellcheck install.sh` and `shfmt -i 2 -d install.sh` are clean; `test -x install.sh`
succeeds; `python3 -c 'import json;json.load(open("claude/.claude/settings.json"))'`
succeeds; `test -f neovim/.stow-local-ignore` succeeds and every line in it mentioning
`gitignore` is a comment line — the two-line header comment names it twice, so a count of
matches is not the check; what matters is that no *pattern* line contains it.

### Slice 4: Drift resolution — DONE

**Goal:** Make the repo content match what is live in `$HOME`, with every difference
accounted for.

Write a throwaway audit script — not committed — that walks `git ls-files`, strips the
leading package component to get the `$HOME`-relative target, and compares byte-for-byte
against `$HOME/<target>`. Skip the repo-root files (`README.md`, `.gitignore`, `install.sh`,
`brewfile`) and `neovim/.stow-local-ignore`. Compare `claude/.claude/skills` as a symlink —
read both link targets rather than their contents, since it is a symlink on both sides.
Report three categories separately: content differs, missing from `$HOME`, and — by diffing
the derived target set against `~/.dotfiles-migration/chezmoi-managed.txt` — managed but
absent from the repo. Print the full report before changing anything.

128 derived targets throughout, and the figures must always sum to 128 — if they sum to 127,
the script dropped `.claude/skills` from the derived set instead of comparing it as a symlink.
Zero managed-but-untracked paths at every point.

The split moves twice, so pin which moment you are measuring:

| Moment | identical | differing | missing |
| --- | --- | --- | --- |
| entering slice 4 | 119 | 7 | 2 |
| six resolutions applied | 125 | 1 | 2 |
| end state | 123 | 3 | 2 |

Entering the slice, the 7 differences are the 6 drifts plus `git/.gitconfig`. Resolving the
drifts leaves only `.gitconfig`. The end state then gains two more deliberate differences
that arrive *after* this slice: the permission substitution below, and the change of the
skills symlink to a relative target while the live link is still chezmoi's absolute one.
Reading any one of those three rows as the whole story is what made two earlier drafts of
this table contradict themselves.

`git/.workGitConfig` is byte-identical to the live file, so it belongs in the identical
group; an earlier draft wrongly counted both git configs as by-design differences.

In the end state the three that differ do so deliberately and none of them is drift:

- `git/.gitconfig` — the one `excludesfile` line, per slice 2
- `claude/.claude/settings.json` — the permission substitution described below, which makes
  the repo copy permanently non-identical to the live one
- `claude/.claude/skills` — the repo symlink is relative (`../../agents/.agents/skills`)
  while the live one is still chezmoi's absolute link. Both resolve to the same skills, and
  the cutover replaces the live link. Compare symlinks by target, so this registers as a
  difference until slice 6 runs.

`claude/.claude/settings.json` needs care: slice 3 already replaced five
`Bash(chezmoi …)` permission entries with `"Bash(stow *)"`, and the live `$HOME` copy still
carries the chezmoi entries. Copying the live file wholesale therefore undoes slice 3 and
reintroduces `chezmoi` into the tree. Take the live file for its model value and key order,
then re-apply the five-for-one permission substitution on top. Slice 3's `git grep -il
chezmoi` condition must still hold when this slice finishes.

Six differences are known and already decided — take the `$HOME` version for each and
commit it:

| File | What the live version has |
| --- | --- |
| `claude/.claude/settings.json` | `"model": "us.anthropic.claude-opus-5[1m]"` and `tui`/`skipWorkflowUsageWarning` key order |
| `opencode/.config/opencode/opencode.json` | MCP servers `context7`, `aws-mcp`, `eng-mcp`, `eng-mcp-dev`; Bedrock region `us-west-2` |
| `lazygit/Library/Application Support/lazygit/config.yml` | `git.diffRenderers` instead of the renamed-away `git.pagers` |
| `ghostty/.config/ghostty/config` | `shell-integration-features = cursor,sudo,ssh-env,ssh-terminfo` with the `# disabled title temporarily to test` comment |
| `agents/.agents/skills/implement-spec/SKILL.md` | the longer TDD wording requiring the skill be invoked with the Skill tool, and red-phase output per behavior |
| `neovim/.config/nvim/nvim-pack-lock.json` | eleven newer plugin revisions; `vim.pack` wrote them and chezmoi's `create_` attribute deliberately never read them back |

Note that the opencode resolution drops six MCP server entries the repo still holds
(`backstage`, `backstage-dev`, `grafana`, `grafana-nonprod`, `atlassian`, `rootly`) in
favour of the `eng-mcp` consolidation the live file moved to. That is the intent.

Two files are expected to differ and must **not** be reconciled: `git/.gitconfig` and
`git/.workGitConfig`. Slice 2 already verified them against chezmoi's rendered output.

Two targets are expected to be missing from `$HOME` and must **not** be treated as errors:
`.agents/docs/specs/2026-08-10-sdd-skills.md` and
`.agents/docs/specs/2026-08-11-back-to-stow.md`. They are source-only until the cutover
installs them; slice 6 verifies they arrive.

Anything else the audit turns up is a genuine unknown: report it and ask before resolving.

**Done when:** the audit reports differences at exactly three paths — `git/.gitconfig`,
`claude/.claude/settings.json`, and `claude/.claude/skills` — and no others; zero paths
missing from `$HOME` outside the two spec files; zero managed-but-untracked paths; and the
full report has been shown. Naming the three explicitly matters: a check phrased as "zero
differences outside the git configs" is unsatisfiable, because two of the three deliberate
exceptions are not git configs.

### Slice 5: Non-destructive preflight — DONE

**Goal:** Prove the full target manifest is correct before anything in `$HOME` is touched.

Commit everything first. Then install the whole tree into a temporary directory that no
existing file can obstruct. The target must not be empty, though: it has to mirror which
directories fold in `$HOME` and which do not, or the rehearsal tests different behavior
than the cutover will produce.

```
TMP="$TMPDIR/stow-preflight"
mkdir -p "$TMP"
# Pre-create every directory that will NOT fold in $HOME, so stow descends into it here
# exactly as it will there.
for d in .claude .config Library "Library/Application Support" \
         "Library/Application Support/lazygit" .config/karabiner .config/nono \
         .config/nono/profiles .config/nvim .config/nvim/spell .config/opencode \
         .config/zed .tmux bin; do
  mkdir -p "$TMP/$d"
done
stow --target="$TMP" --verbose */
```

Skipping that setup produces a false pass on the one bug this slice exists to catch. With an
empty target stow folds `$TMP/.config/nvim` into a single symlink aimed at the repo, so
`$TMP/.config/nvim/.gitignore` resolves through it and appears to exist whether or not stow
would ever have deployed that file. In `$HOME` the directory does not fold, stow links
entry by entry, and a file its ignore list matches is simply dropped. Pre-creating the
no-fold directories is what makes the two runs comparable. `mktemp -d` is unusable here —
the sandbox denies writes under `/var/folders`, so the target must live under `$TMPDIR`.

Run the whole preflight — directory setup, `stow`, the per-path checks, and cleanup — inside
a single shell invocation. `$TMPDIR` does not resolve to the same location across separate
sandboxed tool calls, so a target created in one call is gone by the next, and the checks
then report every target missing against an empty directory. That reads exactly like a total
stow failure and is not one.

Build the expected target list from `git ls-files` by stripping the leading package
component, excluding the repo-root files and `neovim/.stow-local-ignore`. Then test each
expected path for arrival individually:

```
# for each expected target t:
[ -e "$TMP/$t" ] || [ -L "$TMP/$t" ] || echo "MISSING: $t"
```

Every expected target must arrive. Test each path directly rather than enumerating the tree
with `find -L` and diffing: `claude/.claude/skills` is a symlink, so `find -L` descends
through it and lists the skill files underneath while never listing the symlink itself, which
reports a correct migration as missing a target. The per-path test sidesteps that — `-e`
resolves through folded directory symlinks, and `-L` catches a symlink on its own terms.

The missing list must be empty. If `neovim/.config/nvim/.gitignore` appears in it,
`neovim/.stow-local-ignore` from slice 3 is wrong or missing.

Also confirm folding landed where intended: `.agents` must be a single symlink inside
`$TMP`, not a directory. Then `trash "$TMP"`.

A `./install.sh -n` dry run against `$HOME` is not a substitute for this and is not run
here: before the cutover every managed path conflicts, so it reports over a hundred
conflicts and tells you nothing, and a file stow ignores produces no conflict at all.

**Done when:** the missing list is empty; `test -L "$TMP/.agents"` succeeds, proving the one
directory that must fold did; `test -f "$TMP/.config/nvim/.gitignore" && test -L
"$TMP/.config/nvim/.gitignore"` succeeds, proving that file arrived as its own link rather
than through a folded parent; and `$TMP` is removed with `trash`.

### Slice 6: Cutover — DONE

**Goal:** Replace the real files in `$HOME` with symlinks into the repo, reversibly.

Discard the three unmanaged leftovers that block folding, and the fourth that is stale:

- `trash ~/.agents/skills/writing-as-dschaaff-workspace`
- `trash ~/.agents/skills/.claude`
- `trash ~/.config/zellij/config.kdl.bak`
- `trash ~/.config/zed/settings_backup.json`

Move — do not delete — every managed `$HOME` path into one backup directory that preserves
relative structure, so a single command undoes the whole cutover:

```
BK=~/.dotfiles-migration/premigration
mkdir -p "$BK"
# for each path: mkdir -p "$BK/$(dirname "$p")" && mv "$HOME/$p" "$BK/$p"
```

Deriving that list from `git ls-files` alone is not sufficient. Stow deploys whatever sits
in a package directory, tracked or not, so any untracked file inside a package will collide
with its live counterpart and abort the run. Before moving anything, run `git status --short
--ignored --untracked-files=all` and clear every `??` and `!!` entry out of the packages.
One such file existed here: `neovim/.config/nvim/.claude/settings.local.json`, swept into the
package by slice 1 from the old chezmoi source tree. `.chezmoiignore` had deliberately
excluded it, and `settings.local.json` is machine-local by convention, so it belongs in
`$HOME` as a real file and not in a package at all. Note that a `.gitignore` entry does not
protect against this — git ignoring a file has no bearing on whether stow deploys it.

Where a directory is meant to fold, move the directory itself so stow finds it absent;
where it is not, move only the managed entries inside it. Directories to move wholesale:
`~/.agents`, `~/.claude/commands`, `~/.claude/rules`, `~/.config/atuin`, `~/.config/bat`,
`~/.config/ghostty`, `~/.config/goneovim`, `~/.config/k9s`, `~/.config/karabiner/assets`,
`~/.config/nvim/after`, `~/.config/nvim/lua`, `~/.config/nvim/plugin`, `~/.config/ripgrep`,
`~/.config/yamllint`, `~/.config/zellij`, `~/.config/zsh-patina`, `~/.tmux/themes`,
`~/.vim`, `~/.zshfn`.

Then install:

```
./install.sh -n     # must report zero conflicts
./install.sh
```

If the dry run reports any conflict, stop. Do not pass `--adopt` or `--force`, and do not
move anything the dry run did not name. Rollback is `./install.sh -D`, then move the tree
under `$BK` back into `$HOME`.

Verify, then `trash "$BK"` — not before.

**Done when:** all of the following hold.

- `./install.sh -n` reports no conflicts on a second invocation. It will still report actions
  — `--restow` unstows before it stows, so a settled tree shows 61 `UNLINK` plus 61 `LINK`.
  Expecting zero actions is wrong; what matters is zero conflicts and a stable link count.
- For every expected target (derived as in slice 5), `realpath "$HOME/$target"` equals
  `realpath` of its package source exactly, and `cmp -s` of the two reports no difference.
  A prefix match against `/Users/danielschaaff/.dotfiles/` is not sufficient.
- `git status --short` in the repo is empty.
- `~/.agents` is a symlink to `~/.dotfiles/agents/.agents`, and
  `~/.agents/docs/specs/2026-08-11-back-to-stow.md` and `2026-08-10-sdd-skills.md` are both
  readable through it.
- `readlink -f ~/.claude/skills` resolves to `~/.dotfiles/agents/.agents/skills`.
- `~/.claude` is a real directory, not a symlink.
- `test -r ~/.config/nvim/.gitignore` succeeds.
- All six translated scripts are executable: `~/bin/ctrl_t.sh`, `~/bin/tmux-sessionizer`,
  `~/bin/tty-copy`, `~/wezterm.sh`, `~/.zshfn/cleanup_handler_zsh.sh`, `~/.zshfn/kpc`.
- Smoke tests pass: `zsh -ic true`; `nvim --headless +q`; `git config --get user.email`
  prints `daniel@danielschaaff.com`; and the work identity resolves through `includeIf` —
  there is no git repo under `~/development/gitlab/` today, so `git init
  ~/development/gitlab/_stow-check && git -C ~/development/gitlab/_stow-check config --get
  user.email` must print `dschaaff@cordial.com`, then `trash
  ~/development/gitlab/_stow-check`.

### Slice 7: Teardown and merge — DONE

**Goal:** Remove chezmoi from the machine and land the work on master.

Remove chezmoi's config and state, then the binary:

- `trash ~/.config/chezmoi` — holds `chezmoi.toml` and `chezmoistate.boltdb`
- `brew uninstall chezmoi`

Remove the migration scratch directory: `trash ~/.dotfiles-migration`. Do this only after
slice 6 has verified the cutover, since it holds the rollback copy.

Push `back-to-stow` and open a pull request against master. Do not fast-forward or push
master directly — the standing rule is that main is only ever updated through a PR, and the
merge is the user's to perform. Because master's tip is the merge base, the PR will merge
as a fast-forward when they take it.

The PR body describes what the repo does now: a stow package tree, one package per
top-level directory, `./install.sh` to link everything, and the six drift resolutions. It
does not narrate the chezmoi era or the review that reshaped this spec.

**Done when:** `command -v chezmoi` returns nothing; `test -e ~/.config/chezmoi` fails;
`test -e ~/.dotfiles-migration` fails; `git rev-parse origin/back-to-stow` equals local
`HEAD`; `gh pr view --json state,baseRefName` reports an open PR with base `master`; and
`git rev-parse master` is unchanged from before the slice.

## Out of scope

- **Adding, removing, or rewriting any configuration.** Content changes are limited to the
  six drift resolutions in slice 4 and the de-templating in slice 2. No config gets tidied
  along the way.
- **tpm and vim plugin managers.** `~/.tmux/plugins` and `~/.vim/plugged` stay untracked.
  Master carried `tmux/.tmux/plugins/{tmux,tpm}` as git submodules; they are not restored,
  and the README documents cloning tpm by hand.
- **`~/.cordial.sh`.** Stays a plain untracked file in `$HOME`. It holds work secrets and
  chezmoi never managed it.
- **Deduplicating `grill-me` and `grilling`.** `grill-me` is a deliberate user-invocable
  alias carrying `disable-model-invocation: true` that delegates to `/grilling`. Both stay.
- **Portability to a second machine.** The repo assumes it lives at `~/.dotfiles` for a
  single user. Nothing in it hardcodes that path, though: `claude/.claude/skills` is a
  relative symlink resolving inside the repo, so it survives a clone to any location.
- **Pinning non-executable file modes.** Git cannot record them, so files that carried
  chezmoi's `private_` attribute land at whatever the umask yields.
- **A pre-commit hook or CI for this repo.** Verification is the commands named in each
  slice, run by hand.
