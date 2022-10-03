# colorscheme
[ -r "$HOME/.config/base16-google-dark.sh" ] && . "$HOME/.config/base16-google-dark.sh"

# path
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:${HOME}/scripts:/usr/local/opt/libpq/bin:$PATH"

# aliases
alias copy="tr -d '\n' | pbcopy"

# private aliases
[ -r "$HOME/Documents/zsh-private-aliases" ] && . "$HOME/Documents/zsh-private-aliases"

# history
SAVEHIST=1000000
HISTSIZE=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
export HISTORY_IGNORE="(history|ls|cat|vi|vifm|AWS|SECRET|TOKEN|pwgen)"

# disable sessions
export SHELL_SESSIONS_DISABLE=1

# completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# prompt
eval "$(starship init zsh)"

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

# any region for S3 by default
export AWS_REGION=eu-central-1
