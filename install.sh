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
