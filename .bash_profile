export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
export CLICOLOR=1
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

[[ -r "$HOME/.config/base16-google-dark.sh" ]] && . "$HOME/.config/base16-google-dark.sh"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"

GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
PROMPT_COMMAND='__git_ps1 "\w" " \\\$ "'

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=
HISTFILESIZE=

PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
