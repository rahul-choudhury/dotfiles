[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"

export HOMEBREW_NO_ENV_HINTS=1
export SHELL_SESSIONS_DISABLE=1

export FZF_ALT_C_COMMAND='fd -td --min-depth 2 --max-depth 2 . $HOME/Code'

export EDITOR=vim
export VISUAL=vim

export HISTSIZE=50000
export SAVEHIST=10000
export KEYTIMEOUT=1

typeset -U path PATH
path=($HOME/.bun/bin $HOME/.local/bin $path)
export PATH
