# locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# colorscheme
[ -r "$HOME/.config/base16-google-dark.sh" ] && . "$HOME/.config/base16-google-dark.sh"

# completion
export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
[ -r "/usr/local/etc/profile.d/bash_completion.sh" ] && . "/usr/local/etc/profile.d/bash_completion.sh"
[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
[ -r "/usr/local/Caskroom/yandex-cloud-cli/latest/yandex-cloud-cli/completion.bash.inc" ] && . "/usr/local/Caskroom/yandex-cloud-cli/latest/yandex-cloud-cli/completion.bash.inc"
[ -r "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ] && . "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
[ -r "$HOME/.kube/completion" ] && . "$HOME/.kube/completion"
[ -r "/usr/local/bin/mc" ] && complete -C "/usr/local/bin/mc" mc
#_pip_completion()
#{
#    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
#                   COMP_CWORD=$COMP_CWORD \
#                   PIP_AUTO_COMPLETE=1 $1 ) )
#}
#complete -o default -F _pip_completion pip3

# history
shopt -s histappend
export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE=ls:ps:cat:history:vifm
PROMPT_COMMAND="history -a; history -n"

# path
PATH="/usr/local/opt/helm@3/bin:/usr/local/opt/libpq/bin/:/usr/local/sbin:$PATH"

# alias
alias copy="tr -d '\n' | pbcopy"

# prompt
eval "$(starship init bash)"
