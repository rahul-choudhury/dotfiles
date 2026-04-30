eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(fnm env --use-on-cd --shell zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

source <(fzf --zsh)
bindkey -s ^f "tmux-sessionizer\n"

fpath=($HOME/.docker/completions $fpath)

autoload -Uz compinit
compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

alias vim=nvim
alias cdp='cd ~/code/personal/'
alias cdw='cd ~/code/work/'
alias ls='ls --color=auto'
alias ll='ls -lAhsF --color=auto'

function vi-yank-pbcopy {
    zle vi-yank
    echo "$CUTBUFFER" | pbcopy -i
}
zle -N vi-yank-pbcopy

bindkey -M vicmd 'y' vi-yank-pbcopy

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

bindkey '^ ' autosuggest-accept

source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
source "$HOME/.p10k.zsh"

# bun completions
[ -s "/Users/rahul/.bun/_bun" ] && source "/Users/rahul/.bun/_bun"

