#!/usr/bin/env bash

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$_";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
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
    # refer to https://mirrors.ustc.edu.cn/help/rust-static.html
    if [ ! -d "$HTTP_PROXY" ]; then
        export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
        export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
    fi
    rustup self update
    rustup update
}

# restart docker image and remove containers, networks by `docker compose`
function restart_docker() {
    for i in "$@"; do
        docker compose down $i
        docker compose up -d $i
    done
}

# update all docker images and remove dangling images
function update_images() {
    # refer to https://stackoverflow.com/a/48847780/11408830
    docker images | awk '(NR>1) && ($2!~/none/) {print $1":"$2}' | xargs -L1 docker pull
    docker image prune -f
}
