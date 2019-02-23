#!/usr/bin/env bash

set -e

# Color
RED='\e[1;31m'
GREEN='\e[0;32m'
NONE='\e[0m'

# .gitconfig file path
gitconfigFile="$HOME/.gitconfig"

detectGit () {
    # Make sure git is installed
    if test ! $(which git)
    then
        echo 'Please install git.' && exit 1
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

detectGit

moveGitconfig

echo -e "${GREEN}Git have been configured successfully.${NONE}"
