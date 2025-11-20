# Android Studio
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=/opt/homebrew/opt/openjdk

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

# cpp
export PATH="/usr/local/opt/llvm/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# pipx
export PATH="~/.local/bin:$PATH"
