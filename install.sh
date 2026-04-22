#!/bin/bash
set -e

not_installed() {
  if type "$1" >/dev/null 2>&1; then
    return 1
  fi

  return 0
}

if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "After installing CLT, please rerun this script."
  exit 1
fi

export DOTFILES_HOME=~/.dotfiles

if [ ! -d "$DOTFILES_HOME" ]; then
  git clone https://github.com/locol23/dotfiles.git "$DOTFILES_HOME"
  CURRENT_DIRECTORY=$(pwd)
  cd "$DOTFILES_HOME"
  git remote set-url origin git@github.com:locol23/dotfiles.git
  cd "$CURRENT_DIRECTORY"

  defaults write com.apple.dock persistent-apps -array

  # Create dotfiles command for updating tools
  sudo mkdir -p /usr/local/bin
  sudo ln -sf "$DOTFILES_HOME/install.sh" /usr/local/bin/dotfiles
fi

# Mac
# Language
defaults write NSGlobalDomain AppleLanguages -array "en-US" "ja-JP"
# Appearance
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.7
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock mru-spaces -bool "false"
defaults write com.apple.dock show-recents -bool "false"
defaults write com.apple.dock tilesize -int 55
killall Dock
# Keyboard
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1
# Spotlight (disable Cmd+Space to use Raycast instead)
/usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
# Raycast
defaults write com.raycast.macos raycastGlobalHotkey "Command-49"
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
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Terminal
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Homebrew and Formula
if not_installed brew; then
  export PATH=$PATH:/opt/homebrew/bin
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle --file $DOTFILES_HOME/Brewfile --verbose
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
[ ! -f ~/.gitconfig.local ] && cp $DOTFILES_HOME/.gitconfig.local ~/

# Mise
echo
echo "Install Mise"
echo
mkdir -p ~/.config/mise
ln -sf $DOTFILES_HOME/mise.config ~/.config/mise/config.toml
mise install

# Zsh
if ! grep -q '/opt/homebrew/bin/zsh' /etc/shells 2>/dev/null; then
  echo
  echo "Install Zsh"
  echo
  sudo sh -c "echo '/opt/homebrew/bin/zsh' >> /etc/shells"
  sudo chsh -s '/opt/homebrew/bin/zsh' "$USER"
fi
ln -sfn $DOTFILES_HOME/.zsh/ ~/
ln -sf $DOTFILES_HOME/.zshenv ~/
ln -sf $DOTFILES_HOME/.zshrc ~/
ln -sf $DOTFILES_HOME/.zprofile ~/
[ ! -f ~/.zshrc.local ] && cp $DOTFILES_HOME/.zshrc.local ~/

# Neovim
echo
echo "Install Vim"
echo
mkdir -p ~/.config
ln -sfn $DOTFILES_HOME/nvim ~/.config/nvim

# VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false

# AtCoder
if not_installed oj; then
  pipx install online-judge-tools --force
fi

# Golang
eval "$(/opt/homebrew/bin/mise activate bash)"
if ! not_installed go; then
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
ln -sfn $DOTFILES_HOME/.claude/agents ~/.claude/agents
ln -sfn $DOTFILES_HOME/.claude/commands ~/.claude/commands
ln -sfn $DOTFILES_HOME/.claude/skills ~/.claude/skills
ln -sfn $DOTFILES_HOME/.claude/rules ~/.claude/rules
ln -sf $DOTFILES_HOME/.claude/statusline.sh ~/.claude/statusline.sh

# Everything Claude Code rules (update dotfiles rules with latest ECC)
ECC_TMPDIR=$(mktemp -d)
git clone --depth 1 https://github.com/affaan-m/everything-claude-code.git "$ECC_TMPDIR"
cp -pr "$ECC_TMPDIR/rules/common/"* "$DOTFILES_HOME/.claude/rules/"
cp -r "$ECC_TMPDIR/rules/typescript/"* "$DOTFILES_HOME/.claude/rules/"
cp -r "$ECC_TMPDIR/rules/golang/"* "$DOTFILES_HOME/.claude/rules/"
rm -rf "$ECC_TMPDIR"

# Karabiner-Elements
mkdir -p ~/.config/karabiner
ln -sf $DOTFILES_HOME/karabiner.json ~/.config/karabiner/karabiner.json

# SSH
mkdir -p ~/.ssh
ln -sf $DOTFILES_HOME/.ssh/config ~/.ssh/
[ ! -f ~/.ssh/config.local ] && cp $DOTFILES_HOME/.ssh/config.local ~/.ssh/

# espanso
mkdir -p ~/Library/Application\ Support/espanso/match
ln -sf "$DOTFILES_HOME"/espanso/*.yml ~/Library/Application\ Support/espanso/match/
espanso service register 2>/dev/null
echo
echo "espanso: Grant Accessibility permissions in System Settings, then run 'espanso service start'."

exec /opt/homebrew/bin/zsh -l
