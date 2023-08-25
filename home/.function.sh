#!/usr/bin/env bash

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$_";
}

# Update own dotfiles git repository
function update_dotfiles() {
    (cd $DOTFILES_DIR && git pull)
}

function update_nvm() {
    (
        cd "$NVM_DIR"
        git fetch --tags origin
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"
}

# Update rust toolchain and rustup itself
function update_rust() {
    rustup self update
    rustup update
}
