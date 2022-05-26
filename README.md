# dotfiles

Checkout the repo and cd into it

`brew install stow`

```shell
stow neovim vim tmux # etc
```

## MacOS Ulimit Fixes

```shell
sudo launchctl limit maxfiles 10240 $(( 2**63 - 1 ))
```
