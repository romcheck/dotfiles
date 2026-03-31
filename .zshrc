# shellcheck disable=SC1009,SC1036,SC1058,SC1072,SC1073

# path
PATH="$HOME/go/bin:$HOME/bin:$HOME/icloud/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$HOMEBREW_PREFIX/opt/libpq/bin:$HOME/.nodenv/shims:$PATH"

# env variables
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME=base16-256
export EDITOR=hx
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export KUBECONFIG="$HOME/icloud/.kubeconfig"

# default S3 region
export AWS_REGION=eu-central-1

# aliases
alias cn="tr -d '\n' | pbcopy"
alias c=pbcopy
alias ls=eza
alias grep=rg
alias vi=hx
alias vim=hx
alias x=hx
alias v="vifm ."
alias cat="bat -pp"

# disable bell
unsetopt BEEP

# completions
# -U ensures unique elements (no duplicates in FPATH/PATH)
typeset -U fpath FPATH

# add Homebrew completions to fpath
fpath=($HOMEBREW_PREFIX/share/zsh-completions $HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

# fast compinit: only regenerate dump file if it's older than 24h
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# prompt
eval "$(starship init zsh)"

# disable zsh history
HISTFILE=/dev/null
HISTSIZE=0
SAVEHIST=0

# disable zsh session saving
unsetopt SHARE_HISTORY
zstyle ':session:*' auto-save no
zstyle ':session:*' auto-restore no

# init atuin history
eval "$(atuin init zsh)"

# bind CTRL-P to launch atuin search
bindkey '^P' atuin-search

# --- homebrew leaf-only sync ---
brew() {
  command brew "$@"
  local EXIT_CODE=$?
  
  local TRIGGER_COMMANDS=" install rm uninstall reinstall tap untap cask cleanup "
  
  if [[ $EXIT_CODE -eq 0 && "$TRIGGER_COMMANDS" =~ " $1 " ]]; then
    echo "🧹 Syncing clean Brewfile (leaves only)..."
    
    local BREWFILE="$HOME/Brewfile"
    local TEMP_BREWFILE=$(mktemp)
    
    command brew bundle dump --force --file="$TEMP_BREWFILE"
    
    local LEAVES=$(command brew leaves | xargs echo)
    
    {
        command grep -E "^(tap|cask)" "$TEMP_BREWFILE"
        
        command grep "^brew " "$TEMP_BREWFILE" | while read -r line; do
            local pkg=$(echo "$line" | cut -d '"' -f 2)
            if [[ " $LEAVES " == *" $pkg "* ]]; then
                echo "$line"
            fi
        done
    } > "$BREWFILE"
    
    rm "$TEMP_BREWFILE"
    echo "✅ Brewfile updated at $BREWFILE"
  fi
  
  return $EXIT_CODE
}

se() {
  local d="$PWD"
  local files=()

  while [[ "$d" != "/" && "$d" != "$HOME/.." ]]; do
    if [[ -f "$d/secrets.yaml" ]]; then
      files=("$d/secrets.yaml" "${files[@]}")
    fi
    d="${d:h}"
  done

  if [[ ${#files[@]} -eq 0 ]]; then
    "$@"
    return $?
  fi

  local all_env=""
  for f in "${files[@]}"; do
    echo "🔓 Layering: $f"
    local output
    output=$(sops -d --output-type dotenv "$f" 2>/dev/null)
    if [[ $? -eq 0 ]]; then
      all_env+=$'\n'"$output"
    else
      echo "⚠️ Failed to decrypt $f (skipping)"
    fi
  done

  (
    if [[ -n "$all_env" ]]; then
      while IFS= read -r line; do
        [[ -n "$line" && "$line" != "#"* ]] && export "$line"
      done <<< "$all_env"
    fi

    exec "$@"
  )
}

compdef _precommand se
