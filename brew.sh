#!/bin/bash

brew tap caskroom/versions

brew install tmux
brew install reattach-to-user-namespace
brew install tree
brew install node

sudo npm install -g n

sudo n latest

brew cask install visual-studio-code
brew cask install slack
brew cask install sourcetree
brew cask install google-chrome-canary
brew cask install ngrok

# setup zsh
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install nodebrew
curl -L git.io/nodebrew | perl - setup
echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" >> .zshrc
source .zshrc

