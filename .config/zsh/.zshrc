source_if_exists() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

source_if_exists "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"

# deletes local branches not in remote
function gpb() {
  git checkout main
  git fetch -p
  git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
}

# thanks mac
export HISTFILE="$XDG_STATE_HOME/zsh/history"

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY

autoload -Uz compinit edit-command-line add-zsh-hook
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

zstyle ":completion:*" use-cache on
zstyle ":completion:*" cache-path $XDG_CACHE_HOME/zsh/zcompcache
zstyle ":completion:*" menu select
zstyle ":completion:*" rehash true

alias vim=nvim
alias pn=pnpm
alias ls="/opt/homebrew/opt/coreutils/libexec/gnubin/ls --color=auto"
alias ll="ls -lahF --group-directories-first"
alias config="/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME"

bindkey -s ^f "tmux-sessionizer\n"

eval $(/opt/homebrew/bin/brew shellenv)

source_if_exists "$CARGO_HOME/env"

source_if_exists "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
source_if_exists "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source_if_exists "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source_if_exists "$HOME/Developer/powerlevel10k/powerlevel10k.zsh-theme"
source_if_exists "$ZDOTDIR/.p10k.zsh"
