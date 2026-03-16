# shellcheck disable=SC1036,SC1058,SC1072,SC1073

# path
PATH="$HOME/go/bin:$HOME/bin:$HOME/icloud/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$HOMEBREW_PREFIX/opt/libpq/bin:$HOME/.nodenv/shims:$PATH"

# private aliases
#[ -r "$HOME/icloud/.zsh_private_aliases" ] && source "$HOME/icloud/.zsh_private_aliases"

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
FPATH=$HOMEBREW_PREFIX/share/zsh-completions:$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# prompt
eval "$(starship init zsh)"

# disable zsh history
HISTFILE=/dev/null
HISTSIZE=0
SAVEHIST=0

# Disable zsh session saving
unsetopt SHARE_HISTORY  # optional: stops shared history
zstyle ':session:*' auto-save no
zstyle ':session:*' auto-restore no

#Init Atuin without the up-arrow override
eval "$(atuin init zsh --disable-up-arrow)"

# Bind Ctrl-P to launch Atuin search
bindkey '^P' atuin-search

# helix
export HELIX_LOG=/dev/null
