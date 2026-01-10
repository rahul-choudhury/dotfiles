export HOMEBREW_NO_ENV_HINTS=1
export SHELL_SESSIONS_DISABLE=1

export FZF_ALT_C_COMMAND="find $HOME/Code -mindepth 2 -maxdepth 2 -type d"

export VISUAL=vim
export EDITOR=vim

export N_PREFIX=$HOME/.n
export N_PRESERVE_NPM=1
export N_PRESERVE_COREPACK=1

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

typeset -U path PATH
path=($HOME/.local/bin $HOME/.bun/bin $N_PREFIX/bin $HOME/.opencode/bin $path)
export PATH
