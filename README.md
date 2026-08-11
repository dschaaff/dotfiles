# dotfiles

A GNU Stow package tree. Every top-level directory is a package whose contents mirror the
path layout under `$HOME`, so `zsh/.zshrc` deploys to `~/.zshrc`. Files at the repo root
(`README.md`, `install.sh`, `brewfile`, `.gitignore`) are not packages.

Every managed path in `$HOME` is a symlink into this repo. Editing the live file edits the
repo; `git status` is the only drift report. There is no apply or sync step.

## New machine

```shell
brew install stow
git clone git@github.com:dschaaff/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

`install.sh` runs `stow --restow` over every top-level directory, so it both installs and
relinks. Any extra arguments pass through to `stow`:

```shell
./install.sh -n     # dry run — print what would happen, change nothing
./install.sh -D     # unlink everything
```

A real file sitting where stow wants a symlink is a conflict and stow refuses. Move the
file aside and rerun. Do not reach for `--adopt` or `--force`.

## Adding files

Anything created inside a folded directory (`~/.agents`, `~/.claude/rules`, and others that
are a single symlink into the repo) is already in the repo. Everything else needs a new file
in the matching package.

Stow has a built-in ignore list that it applies per package and never reports. A file named
`.gitignore` or `.gitmodules`, or any name ending in `~`, is skipped in silence. To deploy
one, add a `.stow-local-ignore` to that package — it *replaces* the built-in list, so it has
to restate the patterns worth keeping while omitting the one it needs to deploy.
`neovim/.stow-local-ignore` exists for exactly this reason.

## Not tracked

tpm is not in the repo. Clone it by hand:

```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

`~/.cordial.sh` holds work secrets and stays an untracked file in `$HOME`.

## MacOS Ulimit Fixes

```shell
sudo launchctl limit maxfiles 10240 $(( 2**63 - 1 ))
```

## Neovim Notes

Plugins are managed with `vim.pack`; the lockfile is `nvim-pack-lock.json`.
