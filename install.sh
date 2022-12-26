#!/bin/bash

export DOTFILES_HOME=~/.dotfiles

git clone git@github.com:locol23/dotfiles.git $DOTFILES_HOME

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

# Homebrew and Formula
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file $DOTFILES_HOME/Brewfile

# Alacritty
ln -sf $DOTFILES_HOME/.alacritty.yml ~/

# Git
ln -sf $DOTFILES_HOME/.gitconfig ~/
ln -sf $DOTFILES_HOME/.gitignore_global ~/

# Node.js
n latest
ln -sf $DOTFILES_HOME/.npmrc ~/

# Zsh
sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s '/usr/local/bin/zsh'
ln -sf $DOTFILES_HOME/.zsh/ ~/
ln -sf $DOTFILES_HOME/.zshenv ~/
ln -sf $DOTFILES_HOME/.zshrc ~/

# Vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
pip3 install --user pynvim
ln -sf $DOTFILES_HOME/init.vim ~/.config/nvim/init.vim
ln -sf $DOTFILES_HOME/coc-settings.json ~/.config/nvim/coc-settings.json

# AtCoder
pip3 install --user online-judge-tools
 
# Rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
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
ln -sf $DOTFILES_HOME/bttconfig.json ~/

exec $$SHELL -l

