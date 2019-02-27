update:
	@echo 'Update git repository'
	git pull origin master
	git submodule init
	git submodule update

deploy:
	@cp -p .gitconfig ~/
	@cp -p bttconfig.json ~/
	@cp .zshrc ~/
	@echo "export PATH=$$HOME/.nodebrew/current/bin:$$PATH" >> ~/.zshenv

init:
	@echo 'Install Mac Dock settings'
	@defaults write com.apple.dock autohide -bool true
	@defaults write com.apple.dock persistent-apps -array
	@defaults write com.apple.dock tilesize -int 55
	@defaults write com.apple.dock magnification -bool true
	@killall Dock
	@echo 'Install Homebrew and Formula'
	@/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	@brew bundle
	@echo 'Install zsh'
	@sh ./oh-my-zsh/tools/install.sh
	@cp custom.zsh ~/.oh-my-zsh/custom/
	@curl -L git.io/nodebrew | perl - setup
	@MAKE_OPTS="-j 2" nodebrew install-binary latest
	@nodebrew use latest
	@npm i -g now
	@npm i -g lerna

install: update init deploy
	@echo 'Install Success'
	@exec $$SHELL -l

uninstall:
	@echo 'Uninstall settings'
	@rm -f ~/.gitconfig
	@rm -f ~/bttconfig
	@rm -f ~/.zsh*
	@rm -rf ~/.oh-my-zsh/
	@echo 'Uninstall Success'
