#!/bin/zsh
# shellcheck disable=SC1009,SC1036,SC1058,SC1072,SC1073

# path
PATH="$HOME/bin:$HOME/go/bin:$HOME/icloud/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"

# env variables
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME=base16-256
export EDITOR=hx
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export KUBECONFIG="$HOME/icloud/.kubeconfig"
export GOPROXY=pkg-proxy.yasno.dev/go,direct

# default S3 region
export AWS_REGION=eu-central-1

# aliases
alias cn="tr -d '\n' | pbcopy"
alias c="perl -pe 'chomp if eof' | pbcopy"
alias ls=eza
alias h=hx
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
if [[ -n "$HOME/.zcompdump(#qN.mh+24)" ]]; then
  compinit
else
  compinit -C
fi

# mise
eval "$(mise activate zsh)"

# prompt
export STARSHIP_CONFIG=~/.config/starship-zsh.toml
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

# --- secret enclave: hierarchical environment injector for secure cli tooling ---
se() {
  local d="$PWD"
  local files=()

  # collect configuration files up the directory tree
  while [[ "$d" != "/" && "$d" != "$HOME/.." ]]; do
    # secrets are added after vars to ensure they take precedence during export
    [[ -f "$d/.vars.yaml" ]] && files=("$d/.vars.yaml" "${files[@]}")
    [[ -f "$d/.secrets.yaml" ]] && files=("$d/.secrets.yaml" "${files[@]}")
    d="${d:h}"
  done

  if [[ ${#files[@]} -eq 0 ]]; then
    "$@"
    return $?
  fi

  (
    set +x
    trap 'echo "\n❌ Interrupted." >&2; exit 1' INT

    for f in "${files[@]}"; do
      if [[ "$f:t" == ".vars.yaml" ]]; then
        echo "📖 Loading variables: $f" >&2
        # parse plain yaml via yq
        local vars=$(yq e '. | to_entries | .[] | .key + "=" + (.value | @sh)' "$f" 2> /dev/null)
        if [[ -n "$vars" ]]; then
          while IFS= read -r line; do
            export "${(z)line}"
          done <<< "$vars"
        fi
      else
        echo "🔓 Decrypting secret variables: $f" >&2
        # read encrypted secrets via sops
        while IFS= read -r line; do
          if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
            export "${line}"
          fi
        done < <(sops -d --output-type dotenv "$f" 2> /dev/null)

        if [[ $? -ne 0 ]]; then
          echo "❌ Error decrypting $f. Execution halted." >&2
          exit 1
        fi
      fi
    done

    # execute specific commands with args injection
    case "$1" in
      yc)
        local cmd=$1
        shift
        local -a args=("--token" "$YC_TOKEN")
        [[ -n "$YC_CLOUD_ID" ]] && args+=("--cloud-id" "$YC_CLOUD_ID")
        [[ -n "$YC_FOLDER_ID" ]] && args+=("--folder-id" "$YC_FOLDER_ID")
        [[ -n "$YC_ENDPOINT" ]] && args+=("--endpoint" "$YC_ENDPOINT")
        exec "$cmd" "${args[@]}" "$@"
        ;;
      *)
        exec "$@"
        ;;
    esac
  )
}

compdef _precommand se
