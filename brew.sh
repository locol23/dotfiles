#!/bin/bash

brew tap caskroom/versions

brew install reattach-to-user-namespace
brew install tree

brew cask install visual-studio-code
brew cask install franz
brew cask install sourcetree
brew cask install google-chrome-canary
brew cask install ngrok
brew cask install karabiner
brew cask install skitch

# install zsh
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install nodebrew
curl -L git.io/nodebrew | perl - setup
echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" >> .zshrc
source .zshrc
MAKE_OPTS="-j 2" nodebrew install-binary latest

