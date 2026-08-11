# Back to stow

## Problem

The dotfiles repo moved from GNU Stow to chezmoi on 2026-06-18. The chezmoi workflow does
not fit how the files actually get edited. Every change made in `$HOME` — by an app, by
Claude Code, or by hand — has to be pushed back into the source tree with `chezmoi re-add`
before it is tracked. Five files have already drifted out of sync because that step was
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
branch's ancestor commits, which is the rollback path.

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

Stow replaces a whole directory with one symlink when the repo owns every entry in it, and
falls back to per-entry symlinks otherwise. Default folding is kept — it is what master
did, and it is the property that makes new files self-tracking: a rule written into
`~/.claude/rules/` or a skill written into `~/.agents/skills/` is in the repo the moment it
is created.

Folding happens only when the target directory is absent at install time. This is why the
cutover deletes the `$HOME` copies rather than using `stow --adopt`; `--adopt` moves each
conflicting file into the package and links it back individually, which never folds and
would produce roughly 120 per-file symlinks instead of about 40 links total.

Two directories fold only after unmanaged leftovers are cleared: `~/.agents` (blocked by
`skills/writing-as-dschaaff-workspace/`, leftover skill-tuning eval output, and by
`skills/.claude/.cc-writes/`, a Claude Code scratch directory) and `~/.config/zellij`
(blocked by `config.kdl.bak`). All three leftovers are discarded. `.cc-writes` will be
recreated inside the folded tree, so `.gitignore` covers it.

Directories that stay unfolded because an application keeps its own state alongside repo
files: `~/.claude`, `~/.config`, `~/Library`, `~/Library/Application Support`,
`~/Library/Application Support/lazygit`, `~/.config/karabiner`, `~/.config/nono`,
`~/.config/nono/profiles`, `~/.config/nvim`, `~/.config/nvim/spell`, `~/.config/opencode`,
`~/.config/zed`, `~/.tmux`, `~/bin`.

### Translating chezmoi's source attributes

| chezmoi source form | stow form |
| --- | --- |
| `dot_zshrc` | `zsh/.zshrc` |
| `private_karabiner.json` | prefix dropped; file lands at mode `644` |
| `executable_tmux-sessionizer` | prefix dropped; git mode set to `100755` |
| `create_nvim-pack-lock.json` | plain tracked file |
| `symlink_skills.tmpl` | a real symlink committed in the repo |
| `dot_gitconfig.tmpl` | plain config file with literal values |

Two behavior changes follow and are accepted. `private_` files drop from mode `600` to
`644`, because git records only the executable bit, so a stricter mode would not survive a
fresh clone anyway — none of those files hold a credential. And the nvim plugin lockfile
becomes a symlink that `vim.pack` writes through, so lockfile updates appear directly as
repo diffs; this is how it behaved during the stow era, and chezmoi's `create_` attribute
existed only to stop `apply` from clobbering it.

### Git identity in plaintext

`.gitconfig` and `.workGitConfig` were the only templates carrying real data: personal
email, work email, and an SSH signing public key. They become plain files with those
values written literally, which is what master had. All three values are already in this
repo's history from the stow era, and an SSH *public* key is not a secret. The rejected
alternative — keeping `[user]` in an untracked `~/.gitconfig.local` — buys nothing here,
because the values are already published in history, and it adds a hand-written per-machine
file that version control cannot restore.

### The `~/.claude/skills` pointer

Skills live in `~/.agents/skills` so that Claude Code, Codex, and opencode can all reach
them, and `~/.claude/skills` is a pointer at that directory. Under chezmoi this was a
templated symlink. Under stow it becomes a symlink committed in the repo whose target is
the absolute path `/Users/danielschaaff/.agents/skills`, so `~/.claude/skills` resolves
through two hops: `$HOME` link → repo symlink → `~/.agents/skills`. A relative target was
rejected because it would silently depend on the repo sitting exactly one level below
`$HOME`; the absolute path is honest about depending on the home directory and nothing
else.

### Drift resolution: the live file wins

Five files were edited in `$HOME` and never re-added to the chezmoi source. In every case
the `$HOME` mtime is newer than the source's last commit for that file, and the content
confirms the live copy is the intended one. The live version is taken for all five and
committed.

### Ignore rules

`.gitignore` is rewritten from `.chezmoiignore`, which is a cleaner and more complete list
than master's `.gitignore` (that one had duplicated `.gitignore` entries and a stray
`warp`). Paths become package-relative.

The list deliberately covers application-writable paths inside *every* managed directory,
not just the ones that fold today. Fold state is not permanent: `stow --restow` unstows
before it stows, so a directory that stops holding unmanaged files becomes foldable on the
next run, and an app that writes there would then be writing into the repo. Guarding
up front is cheaper than discovering it through a surprise commit.

## Testing

This repo has no test framework and does not need one — it holds configuration, not code.
Verification is by command, and every slice below names the command that proves it. There
is no prior art to follow; the previous spec in this directory (`2026-08-10-sdd-skills.md`)
verified skills by invoking them, which has no analogue here.

The three seams that matter:

1. **Link topology.** For every tracked file, `realpath` of its `$HOME` target resolves to
   a path under `/Users/danielschaaff/.dotfiles`. This catches a missed package, a
   forgotten prefix translation, and a broken symlink in one check. It is the load-bearing
   assertion of the whole migration.
2. **Idempotence.** `./install.sh -n` reports zero conflicts and zero actions on a repo
   that is already stowed. A second real run changes nothing.
3. **The configs still load.** Symlinks can be correct while content is wrong — a template
   delimiter left behind, a lost executable bit. Smoke tests exercise the tools that read
   the files.

## Slices

### Slice 1: Stow package tree

**Goal:** Restructure the source tree into 29 stow packages with chezmoi's filename
attributes stripped, changing no file content.

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
regular file in this slice; slice 2 turns it into a symlink.

Also in this slice, add the two files chosen for tracking that chezmoi never managed. Copy
them from `$HOME`, do not move them; the cutover removes the originals.

- `~/.agents/skills/playwright-cli/` → `agents/.agents/skills/playwright-cli/`
- `~/.config/nono/profiles/my-opencode.jsonc` → `nono/.config/nono/profiles/my-opencode.jsonc`

**Done when:** `git ls-files` shows no path containing `dot_`, `private_`, `executable_`,
or `create_`; every tracked file sits under one of the 29 package directories listed above,
except the root files `README.md`, `.gitignore`, `.chezmoiignore`, and
`.chezmoi.toml.tmpl`; and `git diff --cached -M --stat` shows renames with no content
changes apart from the two newly added paths.

### Slice 2: Content and mode translation

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

Replace `claude/.claude/skills` with a symlink whose target is the literal absolute path
`/Users/danielschaaff/.agents/skills`.

Set git mode `100755` on exactly these six files, using `chmod +x <file>` followed by `git
update-index --chmod=+x <file>` so the bit is recorded in the index and not only on disk:

- `bin/bin/ctrl_t.sh`
- `bin/bin/tmux-sessionizer`
- `bin/bin/tty-copy`
- `wezterm/wezterm.sh`
- `zsh/.zshfn/cleanup_handler_zsh.sh`
- `zsh/.zshfn/kpc`

Every other file in `zsh/.zshfn/` is a zsh autoload function and stays `644`.

**Done when:** `rg -l '\{\{' git/` returns nothing; `git ls-files -s` shows mode `120000`
for `claude/.claude/skills` and `100755` for exactly the six files above and no others;
`git config --file git/.gitconfig --get user.email` prints
`daniel@danielschaaff.com`.

### Slice 3: Repo meta

**Goal:** Remove chezmoi from the repo and add the stow entry points.

Delete `.chezmoi.toml.tmpl` and `.chezmoiignore`.

Restore `brewfile` from master at the repo root: `git checkout master -- brewfile`. It was
deleted as collateral damage in commit `d39b8be` ("Remove stow layout and switch README to
chezmoi") and is where `brew "stow"` is declared.

Add `install.sh` at the repo root, mode `755`, with exactly this content:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# every top-level dir is a stow package
stow --restow --target="$HOME" --verbose "$@" */
```

It must pass `shellcheck` and `shfmt -i 2 -d` clean.

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

claude/.claude/settings.local.json

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

`zsh/.cordial.sh` is intentional even though no such file exists in the package today.
`~/.cordial.sh` holds work secrets and stays a plain untracked file in `$HOME`; the entry
guards against the master-era pattern of parking it inside the package directory, where it
would otherwise be committed.

Rewrite `README.md` to document: `brew install stow`, `git clone` to `~/.dotfiles`,
`./install.sh`, the dry-run (`./install.sh -n`) and unlink (`./install.sh -D`) forms, the
fact that every top-level directory is a package, that editing the live file in `$HOME`
edits the repo, and that tpm must be cloned by hand into `~/.tmux/plugins/tpm` because it
is not tracked. Keep the existing macOS ulimit section.

In `claude/.claude/settings.json`, remove these five permission entries and replace them
with `"Bash(stow *)"`:

```
"Bash(chezmoi diff *)"
"Bash(chezmoi managed *)"
"Bash(chezmoi cat *)"
"Bash(chezmoi verify *)"
"Bash(chezmoi source-path *)"
```

In `agents/.agents/docs/specs/2026-08-10-sdd-skills.md`, correct the stale references:
`~/.dotfiles/dot_agents/skills/<name>/SKILL.md` becomes
`~/.dotfiles/agents/.agents/skills/<name>/SKILL.md`, and the two phrases describing a file
as the "chezmoi source" for `~/.claude/CLAUDE.md` are reworded to name
`claude/.claude/CLAUDE.md` as the stow source. Change nothing else in that file — it is a
completed spec.

**Done when:** `rg -i chezmoi` over the repo returns hits only in this spec file;
`shellcheck install.sh` and `shfmt -i 2 -d install.sh` are clean; `test -x install.sh`
succeeds; `python3 -c 'import json;json.load(open("claude/.claude/settings.json"))'`
succeeds.

### Slice 4: Drift audit and resolution

**Goal:** Establish that the repo content matches what is live in `$HOME`, resolving every
difference before anything is deleted.

Write a throwaway audit script — not committed — that, for every path in `git ls-files`,
strips the leading package component to get the `$HOME`-relative target and diffs the repo
file against `$HOME/<target>`. It must skip the four repo-root files (`README.md`,
`.gitignore`, `install.sh`, `brewfile`), skip the `claude/.claude/skills` symlink, and
report three categories separately: content differs, missing from `$HOME`, and missing from
the repo. Print the full report before changing anything.

Five differences are known and already decided — take the `$HOME` version for each and
commit it:

| File | What the live version has |
| --- | --- |
| `claude/.claude/settings.json` | `"model": "us.anthropic.claude-opus-5[1m]"` and `tui`/`skipWorkflowUsageWarning` key order |
| `opencode/.config/opencode/opencode.json` | MCP servers `context7`, `aws-mcp`, `eng-mcp`, `eng-mcp-dev`; Bedrock region `us-west-2` |
| `lazygit/Library/Application Support/lazygit/config.yml` | `git.diffRenderers` instead of the renamed-away `git.pagers` |
| `ghostty/.config/ghostty/config` | `shell-integration-features = cursor,sudo,ssh-env,ssh-terminfo` with the `# disabled title temporarily to test` comment |
| `agents/.agents/skills/implement-spec/SKILL.md` | the longer TDD wording requiring the skill be invoked with the Skill tool, and red-phase output per behavior |

Note that the opencode resolution drops six MCP server entries the repo still holds
(`backstage`, `backstage-dev`, `grafana`, `grafana-nonprod`, `atlassian`, `rootly`) in
favour of the `eng-mcp` consolidation the live file moved to. That is the intent.

Anything else the audit turns up is a genuine unknown: report it and ask before resolving.

**Done when:** the audit script reports zero content differences and zero
missing-from-`$HOME` paths, and the report has been shown in full.

### Slice 5: Cutover

**Goal:** Replace the real files in `$HOME` with symlinks into the repo.

Commit everything first — nothing in this slice should run against a dirty tree.

Discard the three unmanaged leftovers that block folding, and the fourth that is stale:

- `trash ~/.agents/skills/writing-as-dschaaff-workspace`
- `trash ~/.agents/skills/.claude`
- `trash ~/.config/zellij/config.kdl.bak`
- `trash ~/.config/zed/settings_backup.json`

Remove the `$HOME` copies of every managed path with `trash`, never `rm`. Where a directory
is meant to fold, trash the directory itself so stow finds it absent; where it is not, trash
only the managed entries inside it. Directories to remove wholesale: `~/.agents`,
`~/.claude/commands`, `~/.claude/rules`, `~/.config/atuin`, `~/.config/bat`,
`~/.config/ghostty`, `~/.config/goneovim`, `~/.config/k9s`, `~/.config/karabiner/assets`,
`~/.config/nvim/after`, `~/.config/nvim/lua`, `~/.config/nvim/plugin`, `~/.config/ripgrep`,
`~/.config/yamllint`, `~/.config/zellij`, `~/.config/zsh-patina`, `~/.tmux/themes`,
`~/.vim`, `~/.zshfn`.

Then dry-run and install:

```
./install.sh -n     # must report zero conflicts
./install.sh
```

If the dry run reports any conflict, stop and resolve it — do not pass `--adopt` or
`--force`, and do not delete anything the dry run did not name.

**Done when:** `./install.sh -n` reports no conflicts and no pending actions on a second
invocation; for every tracked file, `realpath` of its `$HOME` target — derived by stripping
the leading package component, the same rule the slice 4 audit uses — begins with
`/Users/danielschaaff/.dotfiles/`; `git status --short` in the repo is empty; `~/.agents`
is a symlink to `~/.dotfiles/agents/.agents`; `readlink -f ~/.claude/skills` resolves to
`~/.dotfiles/agents/.agents/skills`; `test -x ~/bin/tmux-sessionizer` succeeds; and these
smoke tests pass:

- `zsh -ic true`
- `nvim --headless +q`
- `git config --get user.email` prints `daniel@danielschaaff.com`
- the work identity resolves through `includeIf`. There is no git repo under
  `~/development/gitlab/` today, so create a throwaway one to check it: `git init
  ~/development/gitlab/_stow-check && git -C ~/development/gitlab/_stow-check config --get
  user.email` must print `dschaaff@cordial.com`; then `trash
  ~/development/gitlab/_stow-check`.

### Slice 6: Teardown and merge

**Goal:** Remove chezmoi from the machine and land the work on master.

Remove chezmoi's config and state, then the binary:

- `trash ~/.config/chezmoi` — holds `chezmoi.toml` and `chezmoistate.boltdb`
- `brew uninstall chezmoi`

Fast-forward master to `back-to-stow` and push. Do not create a merge commit; master's tip
is the merge base, so `git merge --ff-only` from master succeeds.

**Done when:** `command -v chezmoi` returns nothing; `test -e ~/.config/chezmoi` fails;
`git log --oneline -1 master` matches `back-to-stow`; `git rev-list --count
master..back-to-stow` is `0`.

## Out of scope

- **Adding, removing, or rewriting any configuration.** Content changes are limited to the
  five drift resolutions in slice 4 and the de-templating in slice 2. No config gets tidied
  along the way.
- **tpm and vim plugin managers.** `~/.tmux/plugins` and `~/.vim/plugged` stay untracked.
  Master carried `tmux/.tmux/plugins/{tmux,tpm}` as git submodules; they are not restored,
  and the README documents cloning tpm by hand.
- **`~/.cordial.sh`.** Stays a plain untracked file in `$HOME`. It holds work secrets and
  chezmoi never managed it.
- **Deduplicating `grill-me` and `grilling`.** `grill-me` is a deliberate user-invocable
  alias carrying `disable-model-invocation: true` that delegates to `/grilling`. Both stay.
- **Portability to a second machine.** The repo assumes it lives at `~/.dotfiles` for a
  single user, which is why `claude/.claude/skills` may hold an absolute path.
- **File modes beyond the executable bit.** Git cannot record them, so chezmoi's `private_`
  files land at `644`.
- **A pre-commit hook or CI for this repo.** Verification is the commands named in each
  slice, run by hand.
