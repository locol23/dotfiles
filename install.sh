#!/bin/bash

export DOTFILES_HOME=~/.dotfiles

git clone git@github.com:locol23/dotfiles.git $DOTFILES_HOME

# Mac
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock tilesize -int 55
defaults write com.apple.dock magnification -bool true
killall Dock
defaults write -g KeyRepeat -int 1

# Homebrew and Formula
/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file $DOTFILES_HOME/Brewfile

# Alacritty
ln -sf .alacritty.yml ~/

# Git
.gitconfig
.gitignore_global

# Node.js
n latest
ln -sf .npmrc ~/

# Zsh
sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s '/usr/local/bin/zsh'
ln -sf .zsh/ ~/
ln -sf .zshenv ~/
ln -sf .zshrc ~/

# Vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
pip3 install --user pynvim
ln -sf init.vim ~/.config/nvim/init.vim
ln -sf coc-settings.json ~/.config/nvim/coc-settings.json

# AtCoder
pip3 install --user online-judge-tools
 
# Rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
rustup component add rls rust-analysis rust-src

# Direnv
ln -sf .direnvrc ~/

# Prettier
ln -sf .prettierrc.js ~/

# Tig
ln -sf .tigrc ~/

# Tmux
ln -sf .tmux.conf ~/

# BTT
cp -v bttconfig.json ~/

exec $$SHELL -l

