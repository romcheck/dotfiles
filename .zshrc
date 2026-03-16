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
