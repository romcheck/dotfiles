# shellcheck disable=SC1009,SC1036,SC1058,SC1072,SC1073

# path
PATH="$HOME/go/bin:$HOME/icloud/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$HOMEBREW_PREFIX/opt/libpq/bin:$HOME/.nodenv/shims:$PATH"

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
setopt EXTENDED_GLOB

# add homebrew completions to fpath
fpath=($HOME/.zsh/completions $HOMEBREW_PREFIX/share/zsh-completions $HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

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
    [[ -f "$d/secrets.yaml" ]] && files=("$d/secrets.yaml" "${files[@]}")
    d="${d:h}"
  done

  if [[ ${#files[@]} -eq 0 ]]; then
    exec "$@"
  fi

  (
    set +x

    trap 'echo "\n❌ Decryption interrupted. Aborting." >&2; exit 1' INT

    for f in "${files[@]}"; do
      echo "🔓 Layering: $f" >&2

      while IFS= read -r line; do
        if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
          export "${line}"
        fi
      done < <(sops -d --output-type dotenv "$f" 2>/dev/null)

      if [[ $? -ne 0 ]]; then
        echo "❌ Error decrypting $f. Execution halted." >&2
        exit 1
      fi
    done

    case "$1" in
        kubectl|k9s)
            local cmd="$1"
            shift
            local K8S_TOKEN=$(yc k8s create-token --token "$YC_TOKEN" 2>/dev/null | jq -r '.status.token')

            if [[ -n "$K8S_TOKEN" && "$K8S_TOKEN" != "null" ]]; then
                exec "$cmd" --token="$K8S_TOKEN" "$@"
            else
                echo "ERROR: Failed to extract k8s token. Check if YC_TOKEN is valid." >&2
                exit 1
            fi
            ;;

        yc)
            local cmd="$1"
            shift
            local -a extra_args=("--token" "$YC_TOKEN")
            [[ -n "$YC_CLOUD_ID" ]]  && extra_args+=("--cloud-id" "$YC_CLOUD_ID")
            [[ -n "$YC_FOLDER_ID" ]] && extra_args+=("--folder-id" "$YC_FOLDER_ID")

            exec "$cmd" "${extra_args[@]}" "$@"
            ;;

        *)
            exec "$@"
            ;;
    esac
  )
}

compdef _precommand se
