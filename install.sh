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

# antidote is the zsh plugin manager. Homebrew ships it on the Mac; no other system has a
# package worth relying on, so clone it into the second location .zshrc searches. Keep this
# list in step with the search loop at the top of zsh/.zshrc.
antidote_present() {
  local candidate
  for candidate in \
    /opt/homebrew/opt/antidote/share/antidote/antidote.zsh \
    "$HOME/.antidote/antidote.zsh" \
    /usr/share/zsh-antidote/antidote.zsh; do
    if [ -r "$candidate" ]; then
      return 0
    fi
  done
  return 1
}

if ! antidote_present; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi

# Skills live in their own repo so Codex, pi, and opencode can read them too. Without
# this a fresh machine gets no skills and nothing complains about it.
SKILLS_REPO="$HOME/development/github/agent-skills"
SKILLS_REMOTE="git@github.com:dschaaff/agent-skills.git"

if [ ! -d "$SKILLS_REPO" ]; then
  git clone "$SKILLS_REMOTE" "$SKILLS_REPO"
elif ! git -C "$SKILLS_REPO" remote get-url origin | grep -q 'dschaaff/agent-skills'; then
  printf 'install.sh: %s is not the agent-skills checkout. Skipping skill install.\n' \
    "$SKILLS_REPO" >&2
  exit 1
fi

"$SKILLS_REPO/install.sh"
