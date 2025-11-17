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

# Update nvm and load it
function update_nvm() {
    if [ ! -d "$NVM_DIR" ]; then
        echo "nvm is not installed" && return
    fi

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
function dc_restart() {
    docker_file=$(ls | grep *compose.y*ml)
    if ! [ -f $docker_file ]; then
        echo "can't find docker compose file"
        exist 1
    fi

    for i in "$@"; do
        docker compose down $i
        docker compose up -d $i
    done
}

# update all docker images and remove dangling images
function update_images() {
    DOCKER_MAJOR_VERSION=$(docker --version | awk '{print $3}' | tr -d ',' | cut -d'.' -f1)

    # since docker cli version 29.0.0, the output of `docker images` command has been changed,
    # this function can't match the image name and tag correctly.
    # refer to https://github.com/docker/cli/discussions/6651
    if [[ $DOCKER_MAJOR_VERSION -ge 29 ]]; then
        echo "docker cli output format has changed since version 29.0.0"
        echo "this function can't match and update images correctly"
        return
    fi

    # refer to https://stackoverflow.com/a/48847780/11408830
    docker images | awk '(NR>1) && ($2!~/none/) {print $1":"$2}' | xargs -L1 docker pull
    docker image prune -f
}

# Add specified directory to PATH temporarily if it exists and is not already in PATH
function add_path {
    if [ -z "${1}" ]; then
        echo "no param" && return
    fi
    # determine if the path is absolute or relative
    if [[ "${1}" = /* ]]; then
        INPUT_DIR="${1}"
    else
        INPUT_DIR="$(pwd)/${1}"
    fi
    # determine if the path exists and append it to PATH
    if [[ -d "$INPUT_DIR" ]]; then
        export PATH="${PATH}:$INPUT_DIR"
    else
        echo "the path is not exist or not a directory"
    fi
}

function set_proxy() {
    max_port=65535
    proxy_url="127.0.0.1:1080"
    # http(s) proxy
    if [ -z "${1}" ]; then
        echo "use default 1080 as http port"
    else if
        if [ "${1}" -gt 0 -a "${1}" -lt ${max_port} ] 2>/dev/null; then
            echo "use specified ${1} as http port"
            proxy_url="127.0.0.1:${1}"
        else if
            echo "use specified ${1} as http proxy url"
            proxy_url="${1}"
        fi
    fi
    # socks5 proxy
    socks5_proxy="http://$proxy_url"
    if [ ! -z "${2}" ]; then
        echo "use specified ${2} as socks5 proxy"
        socks5_proxy="socks5://127.0.0.1:${2}"
    fi
    # set proxy env
    export http_proxy="http://${proxy_url}"
    export HTTP_PROXY="http://${proxy_url}"
    export https_proxy="http://${proxy_url}"
    export HTTPS_PROXY="http://${proxy_url}"
    export all_proxy="$socks5_proxy"
    export ALL_PROXY="$socks5_proxy"
}

function unset_proxy() {
    unset http_proxy https_proxy socks_proxy all_proxy
    unset HTTP_PROXY HTTPS_PROXY SOCKS_PROXY ALL_PROXY
}
