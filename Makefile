EXCLUDE := .DS_Store .git .gitmodules
FILES := $(wildcard .??*)
TARGET := $(filter-out $(EXCLUDE), $(FILES))

list:
	@$(foreach val, $(TARGET), ls -dF $(val);)

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
	@/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	@brew bundle
	@echo ''
	@echo 'Install Node.js'
	@echo ''
	@sudo mkdir -p /usr/local/n
	@sudo chown -R $$(whoami) /usr/local/n /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
	@n latest
	@brew install yarn --ignore-dependencies
	@echo ''
	@echo 'Install node modules globally'
	@echo ''
	@yarn global add now
	@echo ''
	@echo 'Install zsh'
	@echo ''
	@sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
	@chsh -s '/usr/local/bin/zsh'
	@echo ''
	@echo 'Install Vim'
	@echo ''
	@curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@pip3 install --user pynvim

deploy:
	@echo ''
	@echo 'Deploy files'
	@echo ''
	@$(foreach val, $(TARGET), cp -rv $(val) ~/;)
	@cp -v bttconfig.json ~/
	@mkdir -p ~/.config/nvim/
	@ln -snfv `pwd`/init.vim ~/.config/nvim/init.vim
	@ln -snfv `pwd`/coc-settings.json ~/.config/nvim/coc-settings.json

install: init deploy
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
	@rm -rf ~/.cache/
	@echo ''
	@echo 'Uninstall Success'
