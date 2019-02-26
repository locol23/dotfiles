export EDITOR=vim

eval "$(direnv hook zsh)"

alias g='git'
alias gbd="g b --merged | grep -vE '^\*|master$|develop$' | xargs -I % git b -d %"
alias d=docker
alias dc=docker-compose
alias vi=nvim
alias vim=nvim
