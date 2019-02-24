#!/usr/bin/env bash

set -e

# Color
RED='\e[1;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
NONE='\e[0m'

# .gitconfig file path
gitconfigFile="$HOME/.gitconfig"

detectGit () {
    # Make sure git is installed
    if test ! $(which git)
    then
        echo -e "${RED}Error${NONE}: Please install git." && exit 1
    fi
}

moveGitconfig () {
    # Move .gitconfig file to $HOME
    if [ -f $gitconfigFile ]
    then
        echo -e "${RED}.gitconfig file already exists in the home directory.${NONE}"
    else
        echo -e "${YELLOW}Copying .gitconfig file to home directory.${NONE}"
        cp `pwd`/.gitconfig $HOME/.gitconfig
        echo -e "${GREEN}Copy .gitconfig file successfully.${NONE}"
    fi
}

detectGit

moveGitconfig

echo -e "${GREEN}Git have been configured successfully.${NONE}"
