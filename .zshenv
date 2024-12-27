export HOMEBREW_NO_ENV_HINTS=1
export SHELL_SESSIONS_DISABLE=1

export N_PREFIX=$HOME/.n
export N_PRESERVE_NPM=1
export N_PRESERVE_COREPACK=1

export BUN_INSTALL=$HOME/.bun

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

export EDITOR=nvim
export VISUAL=nvim

export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

export PATH=$N_PREFIX/bin:$HOME/.local/bin:$BUN_INSTALL/bin:$PATH
