#!/bin/bash
CONFIGS=$(dirname $0)

cd ~
if [ ! -d .bak ]; then
    echo ".bak dir not found. Creating it...";
    mkdir .bak
fi

echo "Moving existing files to backup directory..."
mv .bashrc .bak
mv .gitconfig .bak
mv .vim .bak
mv .vimrc .bak

echo "Linking config files..."
ln -s $CONFIGS/bashrc ~/.bashrc
ln -s $CONFIGS/gitconfig ~/.gitconfig
ln -s $CONFIGS/vim ~/.vim
ln -s $CONFIGS/vimrc ~/.vimrc

echo "Done. Please relog into your shell."
