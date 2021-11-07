_has() {
  return $( whence $1 >/dev/null )
}

function kcsw {
  kc config use-context $(kc config get-contexts -o name | peco)
}

function gsw {
  g sw $(g b -a --sort=-authordate | cut -b 3- | peco | sed -e "s%remotes/origin/%%")
}

# tmux
function ide {
  tmux split-window -v -p 25
  tmux split-window -h -p 50
}

# fzf
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
source /usr/local/opt/fzf/shell/key-bindings.zsh
source /usr/local/opt/fzf/shell/completion.zsh
fi

