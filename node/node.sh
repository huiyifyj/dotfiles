#!/usr/bin/env bash

set -e

if test ! $(which node)
then
    echo 'Install node runtime...'
else
    # Install some package that I personally consider necessary
    npm i -g yarn bower typescript coffeescript
fi
