if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

eval "$(/opt/homebrew/bin/brew shellenv)"
source <(fzf --zsh)

fpath=($HOME/.docker/completions $fpath)

autoload -Uz compinit
compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

alias cdp='cd $HOME/Code/Personal'
alias cdw='cd $HOME/Code/Work'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias ls='ls --color=auto'
alias ll='ls -lAhsF --color=auto'

function vi-yank-pbcopy {
    zle vi-yank
    echo "$CUTBUFFER" | pbcopy -i
}
zle -N vi-yank-pbcopy

bindkey -M vicmd 'y' vi-yank-pbcopy
bindkey '^ ' autosuggest-accept

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
source "$HOME/.p10k.zsh"

# bun completions
[ -s "/Users/rahul/.bun/_bun" ] && source "/Users/rahul/.bun/_bun"
