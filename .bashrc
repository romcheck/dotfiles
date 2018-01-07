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
export PATH=$PATH:$HOME/bin
export HISTFILESIZE=
export HISTSIZE=
export ANSIBLE_VAULT_PASSWORD_FILE="~/.vaultpass"

PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
