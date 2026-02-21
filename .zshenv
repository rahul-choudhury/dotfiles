export HOMEBREW_NO_ENV_HINTS=1
export SHELL_SESSIONS_DISABLE=1

export VISUAL=vim
export EDITOR=vim

export FZF_ALT_C_COMMAND="find ~/code -mindepth 2 -maxdepth 2 -type d"

export N_PREFIX=$HOME/.n
export N_PRESERVE_NPM=1
export N_PRESERVE_COREPACK=1

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

typeset -U path PATH
path=($HOME/.local/bin $N_PREFIX/bin $HOME/.bun/bin $path)
export PATH
