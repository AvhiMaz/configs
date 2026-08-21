plugins+=(macos)

export PATH="$HOME/.local/share/agave/install/active_release/bin:/opt/homebrew/opt/llvm@14/bin:$PATH"
export SBF_TOOLS_PATH="$HOME/.cache/solana/v1.37/platform-tools"

export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"

export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

bindkey '^[→' autosuggest-accept-word

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
