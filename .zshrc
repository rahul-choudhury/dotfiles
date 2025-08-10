if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

fpath=($HOME/.docker/completions $fpath)

autoload -Uz compinit
compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

eval $(/opt/homebrew/bin/brew shellenv)

alias pn=pnpm
alias vim=nvim
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias claude='~/.claude/local/claude'
alias cdp='cd ~/Code/Personal/'
alias cdw='cd ~/Code/Work/'
alias ls='ls --color=auto'
alias ll='ls -lAhsF --color=auto'

function vi-yank-pbcopy {
    zle vi-yank
    echo "$CUTBUFFER" | pbcopy -i
}
zle -N vi-yank-pbcopy
bindkey -M vicmd 'y' vi-yank-pbcopy

source <(fzf --zsh)
bindkey -s ^f "tmux-sessionizer\n"

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"

bindkey '^ ' autosuggest-accept

source "$HOME/.p10k.zsh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
