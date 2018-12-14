#!/usr/bin/env bash

set -e

# Color
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[0;33m'
none='\e[0m'

# .gitconfig file path
zshrcFile="$HOME/.zshrc"

installZsh () {
    # Make sure only root can run our script
    [[ $EUID -ne 0 ]] && echo -e "[${red}Error${none}] This script must be run as root!" && exit 1

    # Install git
    if [ `whoami` == 'root' ]
    then
        sudo apt install zsh
    else
        apt install zsh
    fi
}

moveZshconfig () {
    # Move .gitconfig file to $HOME
    if [ -f $zshrcFile ]
    then
        echo -e "${red}.zshrc file already exists in the home directory.${none}"
    else
        echo "We can not find .zshrc file at the home directory."
        echo "And we will copy file to your home directory."
        cp `pwd`/.zshrc $HOME/.zshrc
    fi
}

if test ! $(which zsh)
then
    installZsh
fi

moveZshconfig
