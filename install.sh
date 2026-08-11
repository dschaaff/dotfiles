#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# ~/.claude holds credentials and session state. Pre-create it so stow never folds the
# whole directory into a single symlink pointing into this repo.
mkdir -p "$HOME/.claude"

# every top-level dir is a stow package
stow --restow --target="$HOME" --verbose "$@" */
