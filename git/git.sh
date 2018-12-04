#!/bin/bash

set -e

# .gitconfig file path
gitconfigFile="$HOME/.gitconfig"

# Color
red='\e[1;31m'
green='\e[0;32m'
yellow='\e[0;33m'
plain='\e[0m'

installGit () {
    # Make sure only root can run our script
    [[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] This script must be run as root!" && exit 1

    # Install git
    if [ `whoami` == 'root' ]
    then
        sudo apt install git
    else
        apt install git
    fi
}

moveGitconfig () {
    # Move .gitconfig file to $HOME
    if [ -f $gitconfigFile ]
    then
        echo -e "${red}.gitconfig file already exists in the home directory.${plain}"
    else
        echo "We can not find .gitconfig file at the home directory."
        echo "And we will copy file to your home directory."
        cp `pwd`/.gitconfig $HOME/.gitconfig
    fi
}

if test ! $(which git)
then
    installGit
fi

moveGitconfig
