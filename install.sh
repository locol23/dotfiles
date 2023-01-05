#!/bin/bash

exist() {
  if type $1 >/dev/null 2>&1; then
    return 1
  fi

  return 0
}

export DOTFILES_HOME=~/.dotfiles

if [ ! -d "$DOTFILES_HOME" ]; then
  git clone https://github.com/locol23/dotfiles.git $DOTFILES_HOME
  
  # Mac
  # Dock
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock magnification -bool true
  defaults write com.apple.dock mineffect -string "scale"
  defaults write com.apple.dock mru-spaces -bool "false"
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock show-recents -bool "false"
  defaults write com.apple.dock tilesize -int 55
  killall Dock
  # Keyboad
  defaults write -g InitialKeyRepeat -int 15
  defaults write -g KeyRepeat -int 1
  # Trackpad
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool "true"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool "true"
  defaults -currentHost write -g com.apple.mouse.tapBehavior -bool "true"
  defaults write -g com.apple.trackpad.scaling 3
  # Battery
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"

  # Create dotfiles command for updating tools
  ln -sf $DOTFILES_HOME/install.sh /usr/local/bin/dotfiles
fi

# Homebrew and Formula
if exist brew; then 
  sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle --file $DOTFILES_HOME/Brewfile

# Alacritty
ln -sf $DOTFILES_HOME/.alacritty.yml ~/

# Git
ln -sf $DOTFILES_HOME/.gitconfig ~/
ln -sf $DOTFILES_HOME/.gitignore_global ~/

# Node.js
if exist n; then
  sudo mkdir -p /usr/local/n
  sudo chown -R $(whoami) /usr/local/n
  n latest
  ln -sf $DOTFILES_HOME/.npmrc ~/
fi

# Zsh
if [ ! -d "$DOTFILES_HOME" ]; then
  sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
  chsh -s '/usr/local/bin/zsh'
  ln -sf $DOTFILES_HOME/.zsh/ ~/
  ln -sf $DOTFILES_HOME/.zshenv ~/
  ln -sf $DOTFILES_HOME/.zshrc ~/
  cp $DOTFILES_HOME/.zshrc.local ~/
fi

# Vim
if [ ! -d "$DOTFILES_HOME" ]; then
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  mkdir -p .config/nvim
  ln -sf $DOTFILES_HOME/init.vim ~/.config/nvim/init.vim
  ln -sf $DOTFILES_HOME/coc-settings.json ~/.config/nvim/coc-settings.json
fi

# AtCoder
if exist oj; then
  pip3 install online-judge-tools
else
  pip3 install online-judge-tools --upgrade
fi
 
# Rust
if exist rustup; then
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
fi
rustup component add rls rust-analysis rust-src

# Direnv
ln -sf $DOTFILES_HOME/.direnvrc ~/

# Prettier
ln -sf $DOTFILES_HOME/.prettierrc.js ~/

# Tig
ln -sf $DOTFILES_HOME/.tigrc ~/

# Tmux
ln -sf $DOTFILES_HOME/.tmux.conf ~/

# BTT
ln -sf $DOTFILES_HOME/bttconfig.json ~/bttconfig.json

# Karabiner-Elements
ln -sf $DOTFILES_HOME/karabiner.json ~/.config/karabiner/karabiner.json

# SSH
mkdir -p ~/.ssh
ln -sf $DOTFILES_HOME/.ssh/config ~/.ssh/

exec $SHELL -l

