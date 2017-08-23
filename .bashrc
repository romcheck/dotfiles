#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\$ '

alias ls='ls --color=auto'
alias vi='vim'
alias grep='grep --ignore-case --color'

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export CCACHE_DIR=/tmp
export EDITOR=vim

PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
