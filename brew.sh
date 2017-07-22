#!/bin/bash

brew tap caskroom/versions

mkdir -p ~/.nodebrew/src
brew install nodebrew
nodebrew install-binary latest

brew install tmux
brew install reattach-to-user-namespace
brew install tree

brew cask install visual-studio-code
brew cask install slack
brew cask install sourcetree
brew cask install google-chrome-canary

chsh -s /bin/zsh

