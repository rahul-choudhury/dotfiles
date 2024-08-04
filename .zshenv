export HOMEBREW_NO_ENV_HINTS=1
export SHELL_SESSIONS_DISABLE=1

export N_PREFIX=$HOME/.n
export N_PRESERVE_NPM=1
export N_PRESERVE_COREPACK=1

export FZF_DEFAULT_OPTS="
--color=fg:#908caa,bg:#232136,hl:#ea9a97
--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
--color=border:#44415a,header:#3e8fb0,gutter:#232136
--color=spinner:#f6c177,info:#9ccfd8,separator:#44415a
--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

export EDITOR=nvim
export VISUAL=nvim

export PATH=$N_PREFIX/bin:$HOME/.local/bin:$PATH

