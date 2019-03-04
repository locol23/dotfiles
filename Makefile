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

init:
	@echo ''
	@echo 'Install Mac Dock settings'
	@echo ''
	@defaults write com.apple.dock autohide -bool true
	@defaults write com.apple.dock persistent-apps -array
	@defaults write com.apple.dock tilesize -int 55
	@defaults write com.apple.dock magnification -bool true
	@killall Dock
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
	@git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	@vim +PluginInstall +qall
	@echo ''
	@echo 'Install Node.js'
	@echo ''
	@yarn global add n
	@sudo mkdir -p /usr/local/n
	@sudo chown -R $(whoami) /usr/local/n
	@sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
	@n latest
	@echo ''
	@echo 'Install node modules globally'
	@echo ''
	@yarn global add now
	@yarn global add lerna

deploy:
	@echo ''
	@echo 'Deploy files'
	@echo ''
	@$(foreach val, $(TARGET), cp -v $(val) ~/;)
	@cp -v bttconfig.json ~/
	@cp -v custom.zsh ~/.oh-my-zsh/custom/
	@mkdir -p ~/.config/nvim/
	@ln -snfv `pwd`/init.vim ~/.config/nvim/init.vim

install: update init deploy
	@echo ''
	@echo 'Install Success'
	@exec $$SHELL -l

uninstall:
	@echo ''
	@echo 'Uninstall settings'
	@$(foreach val, $(TARGET), rm -f ~/$(val);)
	@rm -f ~/bttconfig
	@rm -f ~/.zsh*
	@rm -rf ~/.oh-my-zsh/
	@rm -rf ~/.config/
	@echo ''
	@echo 'Uninstall Success'
