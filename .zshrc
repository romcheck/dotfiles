# shellcheck disable=SC1036,SC1058,SC1072,SC1073

# path
PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$HOME/icloud/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$HOMEBREW_PREFIX/opt/curl/bin:/opt/cprocsp/bin:$HOME/.nodenv/shims:$PATH:$HOME/go/bin"

# private aliases
[ -r "$HOME/icloud/.zsh_private_aliases" ] && source "$HOME/icloud/.zsh_private_aliases"

export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME=base16-256
export EDITOR=hx
export K9S_CONFIG_DIR="$HOME/.config/k9s"

# aliases
alias cn="tr -d '\n' | pbcopy"
alias c=pbcopy
alias ls=eza
alias find=fd
alias ag=rg
alias grep=rg
alias vi=hx
alias vim=hx
alias cat="bat -pp"
# alias docker='colima nerdctl --'

# history
HISTSIZE=500000
HISTFILE=~/icloud/.zsh_history
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

# fzf history
[ -r "$HOMEBREW_PREFIX/bin/fzf" ] && source <(fzf --zsh)

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
