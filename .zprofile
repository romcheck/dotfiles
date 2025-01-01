if [[ $(uname -m) == 'x86_64' ]]; then
  HOMEBREW_PREFIX='/usr/local'
else
  HOMEBREW_PREFIX='/opt/homebrew'
fi

eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
