#!/bin/bash

set -e

echo "Start to initialize your Linux"
echo -e "-----------------------------------------------------------\n"

getDistribution () {
    linux=""

    # Every system that we officially support has /etc/os-release
	if [ -r /etc/os-release ]
    then
		linux="$(. /etc/os-release && echo "$ID")"
	fi

	# Returning an empty string here should be alright since the
	# case statements don't act unless you provide an actual value
	echo "Your linux distribution is ${linux}"
}

getDistribution

initializeConfig () {
    echo "-----------------------------------------------------------"
    echo "Install git and its configuration file."
}

if [ ${linux} == "ubuntu" ] || [ ${linux} == "raspbian" ] || [ ${linux} == "debian" ] || [ ${linux} == "deepin" ]
then
    initializeConfig
else
    echo "We can't support your operation system."
fi
