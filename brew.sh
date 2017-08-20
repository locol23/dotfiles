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

chsh -s /bin/zsh

