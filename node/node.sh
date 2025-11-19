#!/usr/bin/env bash

set -e

# Should install node first:
# - 1. Install node by [nvm](https://github.com/nvm-sh/nvm)
# - 2. Install node manually
# - 3. Install node by [nodesource](https://nodesource.com/)
# - 4. Install node by package manager, like brew for macOS, scoop for Windows

if test ! $(which node)
then
    echo 'Install node runtime...'
else
    # Install some global package that I personally consider necessary
    npm i -g pnpm typescript
fi
