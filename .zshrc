# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Ensure zsh's base autoload functions stay on fpath. After `brew upgrade zsh`
# an inherited/exported FPATH can still point at the previous version's Cellar
# dir (now removed), leaving compinit/add-zsh-hook/vcs_info/colors/is-at-least
# unresolvable. /opt/homebrew/share/zsh/functions always tracks the current zsh.
if [[ -d /opt/homebrew/share/zsh/functions ]]; then
  fpath=(/opt/homebrew/share/zsh/functions $fpath)
fi
typeset -U fpath

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

export PATH="$HOME/go/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
