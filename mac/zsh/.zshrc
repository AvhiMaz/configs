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

export PATH="/Users/avhidotsol/.antigravity/antigravity/bin:$PATH"

change-manager() {
  set -e

  echo "Select package manager:"
  echo "1) npm"
  echo "2) pnpm"
  echo "3) bun"
  read "choice?Enter choice (1/2/3): "

  clean() {
    echo "Cleaning old artifacts..."
    rm -rf node_modules \
      package-lock.json \
      pnpm-lock.yaml \
      bun.lockb
  }

  set_pm_field() {
    local pm=$1
    local version=$2

    if command -v jq >/dev/null 2>&1; then
      jq ".packageManager = \"${pm}@${version}\"" package.json \
        > package.tmp.json && mv package.tmp.json package.json
    else
      echo "jq not found, skipping packageManager field"
    fi
  }

  case $choice in
    1)
      echo "Switching to npm"
      clean
      npm install
      set_pm_field "npm" "$(npm -v)"
      ;;

    2)
      echo "Switching to pnpm"
      if ! command -v pnpm >/dev/null 2>&1; then
        echo "pnpm not found, installing..."
        npm install -g pnpm
      fi
      clean
      pnpm install
      set_pm_field "pnpm" "$(pnpm -v)"
      ;;

    3)
      echo "Switching to bun"
      if ! command -v bun >/dev/null 2>&1; then
        echo "bun not found, installing..."
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
      fi
      clean
      bun install
      set_pm_field "bun" "$(bun -v)"
      ;;

    *)
      echo "Invalid choice"
      return 1
      ;;
  esac

  echo "Package manager switched"
}

alias todo="$HOME/.todo.sh"

echo ""
echo "TODOs"
echo ""
$HOME/.todo.sh display
echo ""

tmux-dev() {
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [[ $- == *i* ]]; then
  SESSION_NAME="personal"
  PERSONAL_DIR="$HOME/Dev/personal"

  if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux new-session -d -s "$SESSION_NAME" -c "$PERSONAL_DIR"
    tmux new-window -t "$SESSION_NAME" -c "$PERSONAL_DIR"
    tmux new-window -t "$SESSION_NAME" -c "$PERSONAL_DIR"
    tmux new-window -t "$SESSION_NAME" -c "$PERSONAL_DIR"
    tmux select-window -t "$SESSION_NAME:0"
  fi

  tmux attach-session -t "$SESSION_NAME"
fi
}
