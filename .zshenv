export HOMEBREW_NO_ENV_HINTS=1
export SHELL_SESSIONS_DISABLE=1

export VISUAL=nvim
export EDITOR=nvim

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

typeset -U path PATH
path=($HOME/.local/bin $HOME/.bun/bin $path)
export PATH
