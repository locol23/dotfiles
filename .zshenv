# homebrew
export PATH=$PATH:/opt/homebrew/bin

# direnv
export EDITOR=vim

# android
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:~/Library/Android/sdk/platform
export PATH=$PATH:~/Library/Android/sdk/tools
export PATH=$PATH:~/Library/Android/sdk/platform-tools

# rust
. "$HOME/.cargo/env"

# deno
export PATH="/Users/terazawa-y/.deno/bin:$PATH"

# golang
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN:/usr/local/bin
export GOVERSION=`ls -l /opt/homebrew/Cellar/go | tail -n 1 | awk '{print $9}'`
export GOROOT="/opt/homebrew/Cellar/go/$GOVERSION/libexec"

# cpp
export PATH="/usr/local/opt/llvm/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

