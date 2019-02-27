config:
	@defaults write com.apple.dock autohide -bool true
	@defaults write com.apple.dock persistent-apps -array
	@defaults write com.apple.dock tilesize -int 55
	@defaults write com.apple.dock magnification -bool true
	@killall Dock

deploy:
	@cat .gitconfig >> ~/.gitconfig
	@cp -p .bttconfig.json ~/
	@/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew:
	@brew bundle

install:
	@cp .zshrc ~/
	@sh ./oh-my-zsh/tools/install.sh
	@cp custom.zsh ~/.oh-my-zsh/custom/
	@exec $SHELL -l
