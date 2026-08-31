# dotfiles

My setup for **macOS** and **Linux**. One config, both machines. The few real
platform differences are handled inside the configs, not by duplicating them.

## How it's built

There is no `mac/` and `linux/` split. Every tool has one directory, and
`install.sh` symlinks it into `$HOME`, so the repo is live: edit a file here
and the change is in effect immediately, no copying or rebuild step.

```
nvim/          neovim, lazy.nvim, single shared config
nvim-portable/ one-file neovim for boxes you ssh into
tmux/          tmux.conf + linux.conf overrides
zsh/           zshrc + darwin.zsh / linux.zsh + todo.sh
ghostty/       terminal config
install.sh     symlinks everything into place
```

Where a machine genuinely needs something different, the shared file branches
on `uname` and pulls in a small per-platform file. That keeps the difference to
a handful of lines instead of two copies of everything that drift apart.

## Getting Started

If you want to use this, fork it first. Then you are working against your own
remote, and you can push your changes back instead of carrying a diff forever.

```sh
git clone https://github.com/<you>/dotfiles.git ~/Dev/dotfiles
cd ~/Dev/dotfiles && ./install.sh
```

`install.sh` symlinks into `$HOME` rather than copying, which is the whole
point: your configs and your git checkout are the same files. Edit, and it is
already applied. Commit when you like it.

Anything already in place is moved to `~/.dotfiles-backup/<timestamp>/` first,
so it is safe to run on a machine that already has configs.

Clone it anywhere you want. Nothing hardcodes the path.

## Platform differences

`zsh/zshrc` is shared and sources `zsh/darwin.zsh` or `zsh/linux.zsh` based on
`uname`. Those hold the parts that genuinely differ: homebrew paths, nvm
location, android sdk on macOS; solana and bun paths, UTF-8 locale and
`stty -ixon` on Linux.

`tmux/tmux.conf` is the base and `tmux/linux.conf` holds the Linux overrides,
sourced last so they win. Config lives in `~/.config/tmux/`, not `~/.tmux.conf`.

|        | prefix | bar                        | clipboard |
| ------ | ------ | -------------------------- | --------- |
| macOS  | `C-k`  | bottom, yellow, full       | `pbcopy`  |
| Linux  | `C-s`  | top, blue, windows + disk  | `xclip`   |

Different prefixes so nesting works: the key tells you which tmux you are
talking to. `C-s` needs flow control off, which `zsh/linux.zsh` handles.

Over ssh, nvim switches to OSC 52 so a yank on the remote lands in the local
clipboard. tmux needs `set-clipboard on` for that to pass through, otherwise it
swallows the sequence. The reverse direction does not exist: terminals refuse to
serve clipboard reads to remote programs, so paste from the local machine is
`Cmd-V`, not `p`.

Everything else is identical on both.

## Remote machines

The config above assumes it is your machine: you clone the repo, run
`install.sh`, and let 34 plugins install. On a box you ssh into once, that is
the wrong trade. `nvim-portable/init.lua` is the same editor in a single file
with no repo, no symlinks, and no install step.

```sh
mkdir -p ~/.config/nvim
wget -O ~/.config/nvim/init.lua \
  https://raw.githubusercontent.com/AvhiMaz/dotfiles/master/nvim-portable/init.lua
nvim
```

First launch bootstraps lazy.nvim and clones the plugins, about thirty seconds.
After that it starts in ~17 ms and occupies 46 MB, against 34 plugins and 1.3 GB
for the full config.

Options, autocmds, and mappings are the same file contents as `nvim/`, so muscle
memory transfers, OSC 52 included. What it keeps: gruvbox, lualine, telescope,
oil, harpoon, gitsigns, nvim-cmp, and lspconfig with the usual `gd` `gr` `K`
`<leader>ca` `<leader>rn`. What it drops: copilot, mason, octo, compile-mode,
wilder, neoclip, lazygit, fugitive, rustaceanvim, treesitter.

Language servers are enabled only when the binary already exists on that
machine, so a bare server gives you a working editor with no errors, and one
that happens to have `gopls` or `clangd` picks them up without being told.
Needs neovim 0.11+; older versions skip the LSP block with a warning rather
than failing to start.

To try it without disturbing an existing setup, put it at
`~/.config/nvimtest/init.lua` and run `NVIM_APPNAME=nvimtest nvim`.

## Requirements

neovim 0.11+, tmux 3.1+, zsh with oh-my-zsh, starship, zoxide, fzf, bat,
ripgrep, fd, and a Nerd Font.

On Linux `fd` is packaged as `fdfind`, so symlink it:

```sh
mkdir -p ~/.local/bin && ln -sf "$(command -v fdfind)" ~/.local/bin/fd
```

tmux draws `_` instead of icons unless the locale name contains `UTF-8`. It
string-matches the name, so `en_IN` fails even though its charmap is UTF-8.
`zsh/linux.zsh` sets `LANG=en_IN.UTF-8`; for everything outside the shell:

```sh
sudo update-locale LANG=en_IN.UTF-8
```
