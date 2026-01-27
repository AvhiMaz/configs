export PATH="$HOME/.local/share/solana/install/active_release/bin:$HOME/.local/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  rust
  dotenv
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias c="clear"
alias ll="ls -lah"

# git aliases
alias g='git'
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'

# npm/pnpm aliases
alias ni='npm install'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrs='npm run start'
alias pi='pnpm install'
alias prd='pnpm run dev'
alias prb='pnpm run build'
alias prs='pnpm run start'

# anchor aliases
alias ab='anchor build'
alias at='anchor test'

vf() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2> /dev/null || cat {}' \
             --preview-window=right:60%:wrap)
  [ -n "$file" ] && nvim "$file"
}

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

bindkey -v

bindkey '^ ' autosuggest-accept

zstyle ':completion:*' correct-prompt 'correct to: %d (y/n/e/a)? '

cdf() {
  local ROOT="${1:-$HOME/dev}"

  local dir
  dir=$(find "$ROOT" -type d -not -path "*/node_modules/*" 2>/dev/null | \
    fzf --height=40% --layout=reverse --border --prompt="Select folder> " \
    --preview="tree -C {} | head -20")

  if [[ -n $dir ]]; then
    cd "$dir"
  fi
}

td() {
  SESSION="dev"

  if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux attach-session -t "$SESSION"
    return
  fi

  tmux new-session -d -s "$SESSION" -n dev

  tmux new-window -t "$SESSION:2" -n build-or-server
  tmux new-window -t "$SESSION:3" -n git
  tmux new-window -t "$SESSION:4" -n validator
  tmux new-window -t "$SESSION:5" -n temp

  tmux select-window -t "$SESSION:1"

  tmux attach-session -t "$SESSION"
}

alias tk='tmux kill-server'

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
