_has() {
  return $( whence $1 >/dev/null )
}

function kcsw {
  kc config use-context $(kc config get-contexts -o name | fzf)
}

# git
function gp {
  if [ "$#" = "1" ]; then
    g config --local user.email "$1"
  fi

  local URL=$(g config --list | grep github.com | grep -v github.com.private | sed -e "s/github.com/github.com.private/g" \
    | sed -e "s/remote.origin.url=//g" | sed -e "s/https:\/\/github.com.private\//git@github.com.private:/g")

  if [ "$URL" != "" ]; then
    g remote set-url origin $URL
  fi
}

function gsw {
  g sw $(g b -a --sort=-authordate | cut -b 3- | fzf | sed -e "s%remotes/origin/%%")
}

# herdr: IDE layout — editor pane on top, two shells across the bottom ~25%.
# (Old tmux: `splitw -p 25` then `splitw -h`.) Run inside a herdr pane.
# `--current` resolves via HERDR_PANE_ID (this shell's pane), so the second
# split must target the new bottom pane's id from the first split's output.
function ide {
  local bottom_pane
  bottom_pane=$(herdr pane split --current --direction down --ratio 0.75 --focus \
    | jq -r '.result.pane.pane_id')

  if [ -z "$bottom_pane" ] || [ "$bottom_pane" = "null" ]; then
    echo "ide: failed to split pane" >&2
    return 1
  fi

  herdr pane split --pane "$bottom_pane" --direction right --focus
}

# fzf
if [ -e /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Docker
function dra {
 docker stop $(docker ps -aq)
 docker rm $(docker ps -aq)
}
