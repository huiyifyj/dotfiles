#!/bin/bash

set -e

# Color
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[0;33m'
plain='\e[0m'

echo "Start to initialize your Linux"
echo -e "\n-----------------------------------------------------------\n"

getDistribution () {

    # Every system that we officially support has /etc/os-release
	if [ -r /etc/os-release ]
    then
		linuxName=$(. /etc/os-release && echo "$ID")
	fi

	# Returning an empty string here should be alright since the
	# case statements don't act unless you provide an actual value
	echo -e "Your linux distribution is ${linuxName}\n"
}

getDistribution

initializeConfig () {
    echo -e "-----------------------------------------------------------\n"
    echo -e "${green} Install git and its configuration file."
}

if [ ${linuxName}=="ubuntu|raspbian|debian|deepin" ]
then
    initializeConfig
else
    echo "We only support operation system based on Debian release."
    echo "You can create pull request if you want to support other os."
fi
