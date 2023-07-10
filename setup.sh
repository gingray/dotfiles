#!/bin/bash

cp -n .ideavimrc $HOME/.ideavimrc
cp -n karabiner.json $HOME/.config/karabiner/karabiner.json
cp -n .global_gitignore $HOME/.global_gitignore
git config --global core.excludesfile $HOME/.global_gitignore
