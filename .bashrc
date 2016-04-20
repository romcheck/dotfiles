#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\$ '

alias ls='ls --color=auto'
alias vi='vim'
alias grep='grep --ignore-case --color'

shopt -s checkwinsize

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export PATH=$PATH:~/bin
export CCACHE_DIR=/tmp
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE='history*'
export BROWSER=chromium
export EDITOR=vim

PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

if [[ -d .docker-machine-bash-completion ]]
then
    . .docker-machine-bash-completion/*
fi
