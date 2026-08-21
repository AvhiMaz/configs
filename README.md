# dotfiles

One config, both machines. macOS and Linux share the same files; the few real
platform differences are handled inside the configs, not by duplicating them.

## Layout

```
nvim/          neovim, lazy.nvim, single shared config
tmux/          tmux.conf
zsh/           zshrc + darwin.zsh / linux.zsh + todo.sh
ghostty/       terminal config
install.sh     symlinks everything into place
```

## Install

```sh
git clone https://github.com/AvhiMaz/dotfiles.git ~/Dev/dotfiles
cd ~/Dev/dotfiles && ./install.sh
```

It symlinks into `$HOME`, so edits in the repo are live. Anything already there
is moved to `~/.dotfiles-backup/<timestamp>/` first.

## Platform differences

`zsh/zshrc` is shared and sources `zsh/darwin.zsh` or `zsh/linux.zsh` based on
`uname`. Those hold the parts that genuinely differ: homebrew paths, nvm
location, android sdk on macOS; solana and bun paths on Linux.

`tmux/tmux.conf` picks `pbcopy` or `xclip` with `if-shell`.

Everything else is identical on both.

## Requirements

neovim 0.11+, tmux, zsh with oh-my-zsh, starship, zoxide, fzf, bat, ripgrep, fd.
On Linux `fd` is packaged as `fdfind`, so symlink it:

```sh
mkdir -p ~/.local/bin && ln -sf "$(command -v fdfind)" ~/.local/bin/fd
```
