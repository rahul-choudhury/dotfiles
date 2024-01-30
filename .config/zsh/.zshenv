export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export TERMINFO=$XDG_DATA_HOME/terminfo
export TERMINFO_DIRS=$XDG_DATA_HOME/terminfo:/usr/share/terminfo

export N_PREFIX=$XDG_DATA_HOME/n

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

export EDITOR="nvim"
export VISUAL="nvim"

typeset -U path PATH
path=($HOME/.local/bin $N_PREFIX/bin $path)

export PATH
