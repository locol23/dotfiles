EXCLUDE := .DS_Store .git .gitmodules
FILES := $(wildcard .??*)
TARGET := $(filter-out $(EXCLUDE), $(FILES))

list:
	@$(foreach val, $(TARGET), ls -dF $(val);)

update:
	@echo ''
	@echo 'Update git repository'
	@echo ''
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

deploy:
	@echo ''
	@echo 'Deploy files'
	@echo ''
	# @cp -p .gitconfig ~/
	@cp -p bttconfig.json ~/
	@cp .zshrc ~/
	@cp custom.zsh ~/.oh-my-zsh/custom/
	@echo "export PATH=$$HOME/.nodebrew/current/bin:$$PATH" >> ~/.zshenv

init:
	@echo ''
	@echo 'Install Mac Dock settings'
	@echo ''
	# @defaults write com.apple.dock autohide -bool true
	# @defaults write com.apple.dock persistent-apps -array
	# @defaults write com.apple.dock tilesize -int 55
	# @defaults write com.apple.dock magnification -bool true
	# @killall Dock
	@echo ''
	@echo 'Install Homebrew and Formula'
	@echo ''
	@/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	@brew bundle
	@echo ''
	@echo 'Install zsh'
	@echo ''
	@sh zsh.sh
	@yarn global add pure-prompt
	@echo ''
	@echo 'Install Node.js'
	@echo ''
	# @curl -L git.io/nodebrew | perl - setup
	# @MAKE_OPTS="-j 2" nodebrew install-binary latest
	# @nodebrew use latest
	# @npm i -g now
	# @npm i -g lerna

install: update init deploy
	@echo ''
	@echo 'Install Success'
	@exec $$SHELL -l

uninstall:
	@echo ''
	@echo 'Uninstall settings'
	@rm -f ~/.gitconfig
	@rm -f ~/bttconfig
	@rm -f ~/.zsh*
	@rm -rf ~/.oh-my-zsh/
	@echo ''
	@echo 'Uninstall Success'
