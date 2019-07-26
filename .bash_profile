export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

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

PATH="/usr/local/Cellar/libpq/11.4/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/sbin:$PATH"

complete -C /usr/local/bin/mc mc

# hxr
export TF_VAR_dotoken=$(envchain hxr printenv DIGITALOCEAN_ACCESS_TOKEN)
export TF_VAR_digitalocean_token=$(envchain hxr printenv DIGITALOCEAN_ACCESS_TOKEN)
alias doctl="envchain hxr doctl"
alias gandi="envchain hxr gandi"
alias kubectl="envchain hxr kubectl"
alias helm="envchain hxr helm"
alias drone="envchain hxr drone"
