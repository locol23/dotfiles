# vi mode for terminal
bindkey -M viins '^]' vi-cmd-mode

# enable ctrl + a and ctrl + e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# start tmux
if [[ -z "$TMUX" ]]; then
  tmux new-session
  exit
fi

# alias
[ ~/.zsh/alias.zsh ] && source ~/.zsh/alias.zsh

# my function
[ ~/.zsh/function.zsh ] && source ~/.zsh/function.zsh

# local config
[ ~/.zshrc.local ] && source ~/.zshrc.local

# plugins
[ ~/.zsh/zinit.zsh ] && source ~/.zsh/zinit.zsh

