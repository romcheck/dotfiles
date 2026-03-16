# shellcheck disable=SC1009,SC1036,SC1058,SC1072,SC1073

# path
PATH="$HOME/go/bin:$HOME/bin:$HOME/icloud/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$HOMEBREW_PREFIX/opt/libpq/bin:$HOME/.nodenv/shims:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME=base16-256
export EDITOR=hx
export K9S_CONFIG_DIR="$HOME/.config/k9s"

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
# alias docker='colima nerdctl --'

# default S3 region
export AWS_REGION=eu-central-1

# disable bell
unsetopt BEEP

# completions
# -U ensures unique elements (no duplicates in FPATH/PATH)
typeset -U fpath FPATH

# Add Homebrew completions to fpath
fpath=($HOMEBREW_PREFIX/share/zsh-completions $HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

# Fast compinit: only regenerate dump file if it's older than 24h
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
unsetopt SHARE_HISTORY  # optional: stops shared history
zstyle ':session:*' auto-save no
zstyle ':session:*' auto-restore no

# init Atuin without the up-arrow override
# eval "$(atuin init zsh --disable-up-arrow)"
eval "$(atuin init zsh)"

# bind CTRL-P to launch Atuin search
bindkey '^P' atuin-search

# disable helix logs
export HELIX_LOG=/dev/null


# --- Homebrew Leaf-Only Sync ---
brew() {
  # Запускаем реальный brew
  command brew "$@"
  local EXIT_CODE=$?
  
  # Расширенный список команд, которые меняют состав пакетов
  # Добавили: rm, uninstall, reinstall, cleanup
  local TRIGGER_COMMANDS=" install rm uninstall reinstall tap untap cask cleanup "
  
  # Обновляем Brewfile только если команда завершилась успешно и она есть в списке триггеров
  if [[ $EXIT_CODE -eq 0 && "$TRIGGER_COMMANDS" =~ " $1 " ]]; then
    echo "🧹 Syncing clean Brewfile (leaves only)..."
    
    local BREWFILE="$HOME/Brewfile"
    local TEMP_BREWFILE=$(mktemp)
    
    # 1. Генерируем полный дамп во временный файл
    command brew bundle dump --force --file="$TEMP_BREWFILE"
    
    # 2. Получаем список "листьев" (только то, что ставилось вручную)
    local LEAVES=$(command brew leaves | xargs echo)
    
    # 3. Фильтруем: оставляем Taps, Casks, Mas и только те brew, что есть в LEAVES
    {
        # Используем 'command grep', чтобы игнорировать твой алиас на 'rg'
        command grep -E "^(tap|cask|mas)" "$TEMP_BREWFILE"
        
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
