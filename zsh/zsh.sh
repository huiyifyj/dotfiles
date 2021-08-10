#!/usr/bin/env bash

set -e

# Color
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[0;33m'
NONE='\e[0m'

# .zshrc file path
zshrcFile="$HOME/.zshrc"

deteceZsh () {
    # Make sure zsh is installed
    if test ! $(which zsh)
    then
        echo -e "${RED}Error${NONE}: Please install zsh." && exit 1
    fi
}

# Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
installOhMyZsh () {
    if test $(which curl)
    then
        echo -e "${YELLOW}Installing oh-my-zsh.${NONE}"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    elif test $(which wget)
    then
        echo -e "${YELLOW}Installing oh-my-zsh.${NONE}"
        sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo -e "${RED}Error${NONE}: Please install curl or wget for oh-my-zsh."
    fi

    echo -e "${GREEN}Install oh-my-zsh successfully.${NONE}"
}

moveZshconfig () {
    # Move .zshrc file to $HOME
    if [ -f $zshrcFile ]
    then
        echo -e "${RED}.zshrc file already exists in the home directory.${NONE}"
    else
        echo -e "${YELLOW}Copying .zshrc file to home directory.${NONE}"
        cp `pwd`/.zshrc $HOME/.zshrc
        echo -e "${GREEN}Copy .zshrc file successfully.${NONE}"
    fi
}

deteceZsh

moveZshconfig

if [ ! -d $HOME/.oh-my-zsh ]
then
    installOhMyZsh
fi

echo -e "${GREEN}Zsh and oh-my-zsh have been configured successfully.${NONE}"
