alias g='git'
alias gbd='{ \
  git branch --merged | grep -vE "^\*|main$|develop$" | xargs git branch -d 2>/dev/null; \
  if command -v gh &> /dev/null; then \
    local branches=($(gh pr list --state merged --limit 100 --json headRefName --jq ".[].headRefName" 2>/dev/null)); \
    for branch in "${branches[@]}"; do \
      git branch -D "$branch" 2>/dev/null && echo "Deleted: $branch (merged on GitHub)"; \
    done; \
  fi; \
}'
alias d=docker
alias dc=docker-compose
alias vi=nvim
alias vim=nvim
alias kc=kubectl
alias kccc="kc config current-context"
alias s=skaffold
alias l="ls -la"
alias ll="ls -l"
alias tf=terraform
alias tg=terragrunt
alias p=pnpm
alias c=claude
