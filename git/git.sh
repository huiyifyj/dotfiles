#!/usr/bin/env bash

set -e

# Color
RED='\e[1;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
NONE='\e[0m'

detectGit () {
    # Make sure git is installed
    if test ! $(which git)
    then
        echo -e "🚨 ${RED}Error${NONE}: Please install git." && exit 1
    fi
}

# Move git-related config files to home directory
# note: param should not contain the dot prefix
moveGitfile () {
    for var in $@
    do
        if [ -f $HOME/.$var ]
        then
            echo -e "✅ ${GREEN}.$var file already exists in the home directory.${NONE}"
        else
            echo -e "⏳ ${YELLOW}Copying .$var file to home directory.${NONE}"
            cp `pwd`/.$var $HOME/.$var
            echo -e "✅ ${GREEN}Copy .$var file successfully.${NONE}"
        fi
    done
}

detectGit

moveGitfile gitconfig gitignore gitattributes gitmessage

echo -e "✅ ${GREEN}Git has been configured successfully.${NONE}"
