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
        echo -e "${red} 文件存在 ${plain}"
    else
        echo "文件不存在"
    fi
}

if test ! $(which git)
then
    installGit
fi

moveGitconfig
