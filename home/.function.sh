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

# Update golang version to latest
function update_go() {
    # refer to https://go.dev/VERSION, use golang.google.cn for China
    VERSION=$(curl -s 'https://golang.google.cn/VERSION?m=text' | awk 'NR==1 {print}')
    OS_NAME=`echo $(uname -s) | tr '[:upper:]' '[:lower:]'`
    OS_ARCH=$(uname -m)
    case $OS_ARCH in
        x86_64)  OS_ARCH="amd64";;
        aarch64) OS_ARCH="arm64";;
        *)       echo "unknown OS architecture: $OS_ARCH" && return;;
    esac

    [ -d $GOROOT ] || (echo "not set GOROOT env" && return)
    (
        cd $GOROOT/..
        TMP_DIR=$(pwd)/go-tmp
        mkdir -p $TMP_DIR
        curl --fail -sL "https://golang.google.cn/dl/$VERSION.$OS_NAME-$OS_ARCH.tar.gz" | tar -C $TMP_DIR -zxv
        echo "remove $GOROOT directory" && rm -rf $GOROOT
        mv $TMP_DIR/go $(pwd)
        echo "remove $TMP_DIR directory" && rm -rf $TMP_DIR
    )
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
