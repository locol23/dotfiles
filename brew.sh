#!/bin/bash

brew tap caskroom/versions

mkdir -p ~/.nodebrew/src
brew install nodebrew

brew install tmux

brew cask install visual-studio-code
brew cask install slack
brew cask install sourcetree
brew cask install google-chrome-canary

chsh -s /bin/zsh

