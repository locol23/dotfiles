### Zinit install
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.zsh/.p10k.zsh ]] || source ~/.zsh/.p10k.zsh

zinit ice wait'!0' atinit"zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait'!0' lucid
zinit snippet OMZ::lib/completion.zsh

zinit ice wait'!0' pick"history.zsh" lucid
zinit snippet OMZ::lib/history.zsh

zinit light zsh-users/zsh-history-substring-search
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=''
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zinit light mollifier/cd-gitroot
autoload -Uz cd-gitroot
alias cdg="cd-gitroot"

