# vi mode for terminal
bindkey -M viins '^]' vi-cmd-mode

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

