# zsh theme
autoload -U promptinit; promptinit
prompt pure

# direnv
export EDITOR=vim
eval "$(direnv hook zsh)"

# rust
export PATH=$HOME/.cargo/bin:$PATH

# deno
export PATH="/Users/terazawa-y/.deno/bin:$PATH"

# alias
alias g='git'
alias gbd="g b --merged | grep -vE '^\*|master$|develop$' | xargs -I % git b -d %"
alias d=docker
alias dc=docker-compose
alias vi=nvim
alias vim=nvim
alias kc=kubectl

# my function
_has() {
  return $( whence $1 >/dev/null )
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
