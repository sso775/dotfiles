#!/bin/bash

DOT_FILES=( .zlogin .zshenv .zshrc .zsh.d .vim .vimrc .gvimrc .emacs.d .screenrc .tmux.conf .tmux.conf.osx .irssi .gitconfig .gitignore.global )

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/local/dotfiles/$file $HOME/$file
done

mv $HOME/.tmux.conf.osx $HOME/.tmux.conf.local
