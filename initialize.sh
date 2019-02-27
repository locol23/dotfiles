#!/bin/bash

# Dock settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock tilesize -int 55
defaults write com.apple.dock magnification -bool true
killall Dock

cat .gitconfig >> ~/.gitconfig
cp -p .bttconfig.json ~/

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle

# install zsh
sh ./oh-my-zsh/tools/install.sh
mkdir -p ~/.oh-my-zsh/custom/
cp custom.zsh ~/.oh-my-zsh/custom/

# install nodebrew
curl -L git.io/nodebrew | perl - setup
echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" >> ~/.zshenv
source ~/.zshenv
MAKE_OPTS="-j 2" nodebrew install-binary latest
nodebrew use latest

npm i -g now
npm i -g lerna
