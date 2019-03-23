# Makefile for implementing all dotfiles

VELOCITY=velocity_v2

default: all

all: zsh tmux vim bash

zsh:
	@ echo "Setting up zsh..."
	@ cp zshrc ~/.zshrc
	@ touch ~/.lastupdate
	@ touch ~/.lastfortune
	@ echo "Complete!"

tmux:
	@ echo "Setting up tmux..."
	@ cp tmux.conf ~/.tmux.conf
	@ mkdir -p ~/.velocity
	@ cp $(VELOCITY)/velocity.py ~/.velocity/velocity.py
	@ cp $(VELOCITY)/velocity.zsh ~/.velocity/velocity.zsh
	@ echo "Complete!"

vim:
	@ echo "Setting up vim..."
	@ cp vimrc ~/.vimrc
	@ echo "To complete vim setup, open vim and run ':PlugInstall'"

bash:
	@ echo "Setting up bash..."
	@ cp bash_profile ~/.bash_profile
	@ echo "Complete!"

yank: yankzsh yanktmux yankvim yankbash

yankzsh:
	@ echo "Retrieving zsh files..."
	@ cp ~/.zshrc zshrc
	@ echo "Complete!"

yanktmux:
	@ echo "Retrieving tmux files..."
	@ cp ~/.tmux.conf tmux.conf
	@ cp ~/.velocity/velocity.py $(VELOCITY)/velocity.py
	@ cp ~/.velocity/velocity.zsh $(VELOCITY)/velocity.zsh
	@ echo "Complete!"

yankvim:
	@ echo "Retrieving vim files..."
	@ cp ~/.vimrc vimrc
	@ echo "Complete!"

yankbash:
	@ echo "Retrieving bash files..."
	@ cp ~/.bash_profile bash_profile
	@ echo "Complete!"

.PHONY: default all zsh tmux vim bash yank yankzsh yanktmux yankvim yankbash

