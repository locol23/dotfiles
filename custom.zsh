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
alias vi=vim

# run tmux
[[ -z "$TMUX" && ! -z "$PS1" ]] && exec tmux

