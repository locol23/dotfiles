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

brew tap caskroom/versions

brew install tree
brew install tig

brew cask install visual-studio-code
brew cask install franz
brew cask install google-chrome-canary
brew cask install ngrok
brew cask install karabiner-elements
brew cask install skitch
brew cask install postman
brew cask install hyper
brew cask install cmd-eikana

# install zsh
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install nodebrew
curl -L git.io/nodebrew | perl - setup
echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" >> ~/.zshrc
source .zshrc
MAKE_OPTS="-j 2" nodebrew install-binary latest
nodebrew use latest

npm i -g now
