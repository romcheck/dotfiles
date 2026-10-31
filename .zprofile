# Homebrew
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

# PATH
export PATH="$HOME/bin:$HOME/go/bin:$HOME/icloud/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$HOMEBREW_PREFIX/opt/libpq/bin:/opt/homebrew/bin:$HOME/Library/Android/sdk/platform-tools:/opt/homebrew/sbin${PATH+:$PATH}"

# Homebrew docs
export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}"
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"

# Environment
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME=base16-256
export EDITOR=hx
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export KUBECONFIG="$HOME/icloud/.kubeconfig"
export GOPROXY=pkg-proxy.yasno.dev/go,direct
export AWS_REGION=eu-central-1
export STARSHIP_CONFIG="$HOME/.config/starship-zsh.toml"
