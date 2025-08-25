export HOMEBREW_NO_ENV_HINTS=1
export SHELL_SESSIONS_DISABLE=1

export N_PREFIX=$HOME/.n
export N_PRESERVE_NPM=1
export N_PRESERVE_COREPACK=1

export GOPATH=$HOME/.go

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

export EDITOR=nvim
export VISUAL=nvim

if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi

typeset -U path PATH
path=($N_PREFIX/bin $HOME/.bun/bin $HOME/.opencode/bin $HOME/.local/bin $path)
export PATH
