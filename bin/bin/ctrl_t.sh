#!/usr/bin/env bash
# set -x
if [[ $# -eq 1 ]]; then
    selected=$1
else
    items="$(fd . --type d ~/development)\n"
    selected=$(echo -e "$items" | fzf)

fi

directory=$(basename $selected | tr . _)

function move () {
    pushd "$selected"
}

move

