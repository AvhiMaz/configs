export PATH="$HOME/.local/share/agave/install/active_release/bin:$HOME/.local/bin:/opt/homebrew/opt/llvm@14/bin:$PATH"
export SBF_TOOLS_PATH="$HOME/.cache/solana/v1.37/platform-tools"
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  rust
  dotenv
  macos
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias c="clear"
alias ll="ls -lah"

vf() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2> /dev/null || cat {}' \
             --preview-window=right:60%:wrap)
  [ -n "$file" ] && nvim "$file"
}

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

bindkey -v

bindkey '^ ' autosuggest-accept
bindkey '^[→' autosuggest-accept-word

zstyle ':completion:*' correct-prompt 'correct to: %d (y/n/e/a)? '
