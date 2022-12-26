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
	@sudo chown -R $$(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@brew bundle
	@echo ''
	@echo 'Install Node.js'
	@echo ''
	@sudo mkdir -p /usr/local/n
	@sudo chown -R $$(whoami) /usr/local/n /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
	@n latest
	@npm install --global yarn
	@echo ''
	@echo 'Install node modules globally'
	@echo ''
	@yarn global add vercel
	@yarn global add graphqurl
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
	@echo 
	@echo 'Install AtCoder commands'
	@echo 
	@yarn global add atcoder-cli
	@pip3 install --user online-judge-tools
	@ln -fs `ls /usr/local/bin | grep -E "^gcc-[0-9]{2}"` /usr/local/bin/gcc
	@ln -fs `ls /usr/local/bin | grep -E "^g\+\+-[0-9]{2}"` /usr/local/bin/g++
	@echo 
	@echo 'Install Rust'
	@echo 
	@$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
	@rustup component add rls rust-analysis rust-src

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
	@rustup self uninstall
	@echo ''
	@echo 'Uninstall Success'
