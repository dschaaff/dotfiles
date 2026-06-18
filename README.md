# dotfiles

Managed with [chezmoi](https://www.chezmoi.io). This repo is the chezmoi source;
files are named with chezmoi's source conventions (`dot_` → `.`, `private_` → mode
`0600`, `executable_` → mode `0755`, `*.tmpl` → templated).

## New machine

```shell
brew install chezmoi          # and have 1Password running for SSH signing
git clone git@github.com:dschaaff/dotfiles.git ~/.dotfiles
printf 'sourceDir = "~/.dotfiles"\n' > ~/.config/chezmoi/chezmoi.toml
chezmoi init                  # prompts for emails, signing key, SSO url/region, CodeRabbit machine id
chezmoi apply -v              # writes real files into $HOME
```

`chezmoi init` runs the prompts in `.chezmoi.toml.tmpl` once and stores the answers in
`~/.config/chezmoi/chezmoi.toml` (machine-local, never committed). Re-running `init` or
`apply` will not re-prompt.

## Daily workflow

```shell
chezmoi edit ~/.zshrc         # edit the source, then apply
chezmoi apply -v              # write pending changes into $HOME
chezmoi diff                  # preview pending changes
chezmoi status                # short status of managed files
chezmoi add ~/.config/foo     # start managing a new file
chezmoi re-add                # pull live edits back into the source
chezmoi cd                    # drop into ~/.dotfiles to git add/commit/push
```

Templated files (machine-specific values pulled from the prompts):

- `dot_gitconfig.tmpl` — personal email, SSH signing key, CodeRabbit machine id
- `dot_workGitConfig.tmpl` — work email, signing key (used by `includeIf` in work dirs)
- `dot_claude/settings.json.tmpl` — AWS SSO start URL and region

`.chezmoiignore` lists runtime/state files and plugin-manager directories that chezmoi
does not manage.

`com.googlecode.iterm2.plist` and `.config/karabiner/karabiner.json` are rewritten by their
apps at runtime, so `chezmoi diff` may show churn. Run `chezmoi re-add` on them before
committing to pick up live changes.

## MacOS Ulimit Fixes

```shell
sudo launchctl limit maxfiles 10240 $(( 2**63 - 1 ))
```

## Neovim Notes

Plugins are managed with `vim.pack`; the lockfile is `nvim-pack-lock.json`.
