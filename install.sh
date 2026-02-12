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
  CURRENT_DIRECTORY=$(pwd)
  cd $DOTFILES_HOME
  git remote set-url origin git@github.com:locol23/dotfiles.git
  cd $CURRENT_DIRECTORY

  # Mac
  # Dock
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0.7
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
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
  defaults write com.apple.dock showMissionControlGestureEnabled -boolean true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
  # Battery
  defaults write com.apple.menuextra.battery ShowPercent -string "YES"
  # Finder
  defaults write com.apple.finder DisableAllAnimations -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  # Terminal
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Create dotfiles command for updating tools
  sudo ln -sf $DOTFILES_HOME/install.sh /usr/local/bin/dotfiles
fi

# Homebrew and Formula
if exist brew; then
  export PATH=$PATH:/opt/homebrew/bin
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle --file $DOTFILES_HOME/Brewfile
brew services start ollama

# Ghostty
echo
echo "Install Ghostty"
echo
mkdir -p ~/.config/ghostty
ln -sf $DOTFILES_HOME/ghostty.config ~/.config/ghostty/config

# Git
ln -sf $DOTFILES_HOME/.gitconfig ~/
ln -sf $DOTFILES_HOME/.gitignore_global ~/
cp $DOTFILES_HOME/.gitconfig.local ~/

# Mise
echo
echo "Install Mise"
echo
mkdir -p ~/.config/mise
ln -sf $DOTFILES_HOME/mise.config ~/.config/mise/config.toml
mise install

# Zsh
if [ ! -d ~/.zsh ]; then
  echo
  echo "Install Zsh"
  echo
  sudo sh -c "echo '/opt/homebrew/bin/zsh' >> /etc/shells"
  chsh -s '/opt/homebrew/bin/zsh'
  ln -sf $DOTFILES_HOME/.zsh/ ~/
  ln -sf $DOTFILES_HOME/.zshenv ~/
  ln -sf $DOTFILES_HOME/.zshrc ~/
  cp $DOTFILES_HOME/.zshrc.local ~/
  ln -sf $DOTFILES_HOME/.zprofile ~/
  cp $DOTFILES_HOME/.zshrc.local ~/
fi

# Neovim
echo
echo "Install Vim"
echo
mkdir -p ~/.config
ln -sf $DOTFILES_HOME/nvim ~/.config/nvim

# VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false

# AtCoder
if exist oj; then
  pipx install online-judge-tools --force
fi

# Golang
if exist go; then
  echo
  echo "Install golang tools"
  echo

  go install github.com/bufbuild/buf/cmd/buf@latest
  go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
  go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
  go install github.com/bufbuild/connect-go/cmd/protoc-gen-connect-go@latest
fi

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

# Claude Code
mkdir -p ~/.claude
ln -sf $DOTFILES_HOME/.claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf $DOTFILES_HOME/.claude/settings.json ~/.claude/settings.json

# Karabiner-Elements
if [ ! -d ~/.config/karabiner ]; then
  mkdir -p ~/.config/karabiner
  ln -sf $DOTFILES_HOME/karabiner.json ~/.config/karabiner/karabiner.json
fi

# SSH
mkdir -p ~/.ssh
ln -sf $DOTFILES_HOME/.ssh/config ~/.ssh/

# espanso
mkdir -p ~/Library/Application\ Support/espanso/match
ln -sf $DOTFILES_HOME/espanso/*.yml ~/Library/Application\ Support/espanso/match/
espanso daemon &

exec $SHELL -l
