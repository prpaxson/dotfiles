# Makefile for implementing all dotfiles

.PHONY: default all zsh tmux vim bash yank yankzsh yanktmux yankvim yankbash install
.SILENT: default all zsh tmux vim bash yank yankzsh yanktmux yankvim yankbash install

VELOCITY=velocity_v2

default: all

all: zsh tmux vim bash

zsh:
	echo "Setting up zsh..."
	cp zshrc ~/.zshrc
	touch ~/.lastupdate
	touch ~/.lastfortune
	echo "Complete!"

tmux:
	echo "Setting up tmux..."
	cp tmux.conf ~/.tmux.conf
	mkdir -p ~/.velocity
	cp $(VELOCITY)/velocity.py ~/.velocity/velocity.py
	cp $(VELOCITY)/velocity.zsh ~/.velocity/velocity.zsh
	echo "Complete!"

vim:
	echo "Setting up vim..."
	cp vimrc ~/.vimrc
	echo "To complete vim setup, open vim and run ':PlugInstall'"

bash:
	echo "Setting up bash..."
	cp bash_profile ~/.bash_profile
	echo "Complete!"

yank: yankzsh yanktmux yankvim yankbash

yankzsh:
	echo "Retrieving zsh files..."
	cp ~/.zshrc zshrc
	echo "Complete!"

yanktmux:
	echo "Retrieving tmux files..."
	cp ~/.tmux.conf tmux.conf
	cp ~/.velocity/velocity.py $(VELOCITY)/velocity.py
	cp ~/.velocity/velocity.zsh $(VELOCITY)/velocity.zsh
	echo "Complete!"

yankvim:
	echo "Retrieving vim files..."
	cp ~/.vimrc vimrc
	echo "Complete!"

yankbash:
	echo "Retrieving bash files..."
	cp ~/.bash_profile bash_profile
	echo "Complete!"

install: all
	echo "Beginning installation of prerequisites..."
	echo "Setting default shell..."
	chsh -s /bin/zsh
	echo "Complete!"
	zsh
	echo "Installing Prezto..."
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	echo "Complete!"
	echo "Installing tmux..."
	ifeq ($(UNAME_S),Darwin)
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew install libevent ncurses tmux
	endif
	echo "Complete!"
	echo "Installing tmux plugin manager..."
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "Complete!"
	echo "Installing powerline fonts..."
	# clone
	git clone https://github.com/powerline/fonts.git --depth=1
	# install
	cd fonts
	./install.sh
	# clean-up a bit
	 cd ..
	rm -rf fonts
	echo "Complete!"
	echo "Installing vim plugin manager..."
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	echo "Complete!"


