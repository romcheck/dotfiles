# default locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# colorscheme
[[ -r "$HOME/.config/base16-google-dark.sh" ]] && . "$HOME/.config/base16-google-dark.sh"

# completions and prompt
export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ]] && . "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"
[[ -r "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ]] && . "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
complete -C /usr/local/bin/mc mc
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip3
GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
PROMPT_COMMAND='__git_ps1 "\w" " \\\$ "'

# unlimited history without dups
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=
HISTFILESIZE=
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# search for local binaries first
PATH="/usr/local/opt/helm@2/bin:/usr/local/opt/libpq/bin/:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/sbin:$PATH"

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/Users/romcheck/yandex-cloud/path.bash.inc' ]; then source '/Users/romcheck/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/Users/romcheck/yandex-cloud/completion.bash.inc' ]; then source '/Users/romcheck/yandex-cloud/completion.bash.inc'; fi
