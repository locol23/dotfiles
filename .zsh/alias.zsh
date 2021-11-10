alias g='git'
alias gbd="g b --merged | grep -vE '^\*|main$|develop$' | xargs -I % git b -d %"
alias d=docker
alias dc=docker-compose
alias vi=nvim
alias vim=nvim
alias kc=kubectl
alias kccc="kc config current-context"
alias s=skaffold
alias l="ls -la"
alias ll="ls -l"

