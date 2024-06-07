export HOMEBREW_NO_ENV_HINTS=1
export SHELL_SESSIONS_DISABLE=1

export N_PREFIX=$HOME/.n

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

export EDITOR=vim
export VISUAL=vim

typeset -U path PATH
path=($N_PREFIX/bin $path)

export PATH
