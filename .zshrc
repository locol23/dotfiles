# enable vi mode on terminal
bindkey -M viins '^]' vi-cmd-mode

# enable ctrl + r on terminal
bindkey -v
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

# enable ctrl + a and ctrl + e on terminal
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# start tmux
if [[ -z "$TMUX" ]]; then
  tmux new-session
  exit
fi

# enable direnv
eval "$(direnv hook zsh)"

# enable mise
eval "$(/opt/homebrew/bin/mise activate zsh)"

# mysql
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# alias
[ ~/.zsh/alias.zsh ] && source ~/.zsh/alias.zsh

# my function
[ ~/.zsh/function.zsh ] && source ~/.zsh/function.zsh

# local config
[ ~/.zshrc.local ] && source ~/.zshrc.local

# plugins
[ ~/.zsh/zinit.zsh ] && source ~/.zsh/zinit.zsh

# ruby
eval "$(rbenv init - zsh)"

export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
