# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("$HOME/.zsh/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# enable vi mode on terminal
bindkey -M viins '^]' vi-cmd-mode

# enable ctrl + r on terminal
bindkey -v
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

# enable ctrl + a on terminal
bindkey '^A' beginning-of-line

# edit command
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line

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
[ -f ~/.zsh/alias.zsh ] && source ~/.zsh/alias.zsh

# my function
[ -f ~/.zsh/function.zsh ] && source ~/.zsh/function.zsh

# local config
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# plugins
[ -f ~/.zsh/zinit.zsh ] && source ~/.zsh/zinit.zsh

# ruby
eval "$(rbenv init - zsh)"

export PATH="$HOME/go/bin:$PATH"
