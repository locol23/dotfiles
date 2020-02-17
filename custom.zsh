# vi mode for terminal
set -o vi

# zsh theme
autoload -U promptinit; promptinit
prompt pure

# direnv
export EDITOR=vim
eval "$(direnv hook zsh)"

# alias
alias g='git'
alias gbd="g b --merged | grep -vE '^\*|master$|develop$' | xargs -I % git b -d %"
alias d=docker
alias dc=docker-compose
alias vi=nvim
alias vim=nvim
alias kc=kubectl
alias kccc="kc config current-context"

# my function
_has() {
  return $( whence $1 >/dev/null )
}

function kcsw {
  kc config use-context $(kc config get-contexts -o name | peco)
}

function gsw {
  g sw $(g b -a --sort=-authordate | cut -b 3- | peco | sed -e "s%remotes/origin/%%")
}

function ide {
  tmux split-window -v -p 25
  tmux split-window -h -p 66
  tmux split-window -h -p 50
}

# fzf
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
source /usr/local/opt/fzf/shell/key-bindings.zsh
source /usr/local/opt/fzf/shell/completion.zsh
fi

# fzf + ag
if _has fzf && _has ag; then
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168
'
fi

# ag
if _has ag; then
  alias ack=ag
  alias ag='ag --color-path 1\;31 --color-match 1\;32 --color'
fi

. ~/.oh-my-zsh/custom/custom.local.zsh
