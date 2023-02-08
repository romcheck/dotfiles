# colorscheme
[ -r "$HOME/.config/base16-google-dark.sh" ] && . "$HOME/.config/base16-google-dark.sh"

# path
PATH="$(brew --prefix)/opt/libpq/bin:${HOME}/Documents/bin:$PATH"

# aliases
alias copy="tr -d '\n' | pbcopy"
#alias cat=bat
alias ag=rg

# private aliases
[ -r "$HOME/Documents/.zsh_private_aliases" ] && . "$HOME/Documents/.zsh_private_aliases"

# history
SAVEHIST=1000000
HISTSIZE=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
export HISTORY_IGNORE="(history|ls|cat|vi|vifm|AWS|SECRET|TOKEN|pwgen)"

# completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# prompt
eval "$(starship init zsh)"

# any region for S3 by default
export AWS_REGION=eu-central-1
#export PULUMI_K8S_SUPPRESS_HELM_HOOK_WARNINGS=true
#export PULUMI_K8S_SUPPRESS_DEPRECATION_WARNINGS=true

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(nodenv init -)"
