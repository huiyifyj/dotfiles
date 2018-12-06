#!/bin/bash

set -e

# Install Node

if test ! $(which node)
then
    echo 'Install node runtime...'
else
    npm i -g yarn bower
fi
