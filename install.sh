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
