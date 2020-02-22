### Zinit install
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# plugins
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
autoload -U promptinit; promptinit
PURE_CMD_MAX_EXEC_TIME=10
zstyle :prompt:pure:git:stash show yes
prompt pure

zinit ice wait'!0' atinit"zpcompinit; zpcdreplay"
zinit light zdharma/fast-syntax-highlighting

zinit ice wait'!0' lucid
zinit snippet OMZ::lib/completion.zsh

zinit ice wait'!0' pick"history.zsh" lucid
zinit snippet OMZ::lib/history.zsh

zinit ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zinit light direnv/direnv

zinit light zsh-users/zsh-history-substring-search
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=''
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zinit light jonmosco/kube-ps1
PROMPT='$(kube_ps1) '$PROMPT

zinit light mollifier/cd-gitroot
autoload -Uz cd-gitroot
alias cdg="cd-gitroot"

