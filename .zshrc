# path
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$(brew --prefix)/opt/libpq/bin:${HOME}/Documents/bin:$(brew --prefix)/opt/coreutils/libexec/gnubin:$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"

export XDG_CONFIG_HOME="${HOME}/.config"
export BAT_THEME=base16
export EDITOR=hx
export K9S_CONFIG_DIR="${HOME}/.config/k9s"

# aliases
alias cn="tr -d '\n' | pbcopy"
alias c=pbcopy
alias cat="bat -pp"
alias find=fd
alias ag=rg
alias grep=rg
alias vi=hx
alias vim=hx
# alias docker='colima nerdctl --'

# private aliases
[ -r "${HOME}/Documents/.zsh_private_aliases" ] && source "${HOME}/Documents/.zsh_private_aliases"

# history
HISTSIZE=500000
export SAVEHIST=500000
export HISTSIZE=$SAVEHIST
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the :start:elapsed;command format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# disable bell
unsetopt BEEP

# completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# prompt
eval "$(starship init zsh)"

# default S3 region
export AWS_REGION=eu-central-1

# fzf history
[ -f ~/.fzf.zsh ] && source "${HOME}/.fzf.zsh"

# nodejs version manager
eval "$(nodenv init -)"
