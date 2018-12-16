#!/usr/bin/env bash

set -e

# Color
RED='\e[1;31m'
GREEN='\e[0;32m'
NONE='\e[0m'

# .gitconfig file path
gitconfigFile="$HOME/.gitconfig"

installGit () {
    # Make sure only root can run our script
    [[ $EUID -ne 0 ]] && echo -e "[${RED}Error${NONE}] This script must be run as root!" && exit 1

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
        echo -e "${RED}.gitconfig file already exists in the home directory.${NONE}"
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
