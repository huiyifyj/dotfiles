#!/usr/bin/env bash

set -e

# Should install node first:
# - 1. Install node by [nvm](https://github.com/creationix/nvm)
# - 2. Install node manually
# - 3. Install node by [nodesource](https://nodesource.com/)

if test ! $(which node)
then
    echo 'Install node runtime...'
else
    # Install some global package that I personally consider necessary
    npm i -g typescript
fi
