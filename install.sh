#!/usr/bin/env bash

set -e

# Color
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[0;33m'
NONE='\033[0m'

get_os() {
    # Cache the output of uname so we don't
    # have to spawn it multiple times.
    IFS=" " read -ra uname <<< "$(uname -srm)"

    OS_NAME="${uname[0]}"
    KERNEL_VERSION="${uname[1]}"
    OS_ARCH="${uname[2]}"

    # $OS_NAME is just the output of "uname -s".
    case $OS_NAME in
        Linux|GNU*)           OS="Linux";;
        Darwin)               OS="macOS";;
        CYGWIN*|MSYS*|MINGW*) OS="Windows";;
        *)
            # https://stackoverflow.com/questions/818255/in-the-shell-what-does-21-mean
            printf '%s\n' "[${RED}Error${NONE}] Unknown OS detected: '$OS_NAME', aborting..." >&2
            exit 1
        ;;
    esac
}

get_distro() {
    [[ $OS_DISTRO ]] && return

    case $OS_NAME in
        Linux)   linux_distro;;
        Darwin)  OS_DISTRO="macOS";;
        Windows)
            OS_DISTRO=$(wmic os get Caption)
            OS_DISTRO=${OS_DISTRO/Caption}
            OS_DISTRO=${OS_DISTRO/Microsoft }
        ;;
    esac
}

linux_distro() {
    # Armbian
    if [[ -f /etc/armbian-release ]]; then
        . /etc/armbian-release
        OS_DISTRO="Armbian"

    elif type -p lsb_release >/dev/null; then
        OS_DISTRO=$(lsb_release -si)

    elif [[ -f /etc/os-release || \
            -f /usr/lib/os-release || \
            -f /etc/openwrt_release || \
            -f /etc/lsb-release ]]; then

        # Source the os-release file
        for file in /etc/lsb-release /usr/lib/os-release \
                    /etc/os-release  /etc/openwrt_release; do
            source "$file" && break
        done

        # Format the distro name.
        OS_DISTRO="${NAME:-${DISTRIB_ID:-${TAILS_PRODUCT_NAME}}}"

    # Android
    elif [[ -d /system/app/ && -d /system/priv-app ]]; then
        OS_DISTRO="Android $(getprop ro.build.version.release)"

    # Chrome OS doesn't conform to the /etc/*-release standard.
    # While the file is a series of variables they can't be sourced
    # by the shell since the values aren't quoted.
    elif [[ -f /etc/lsb-release && $(< /etc/lsb-release) == *CHROMEOS* ]]; then
        OS_DISTRO='Chrome OS'

    # Replace $OS_DISTRO with kernel version $KERNEL_VERSION.
    else
        for release_file in /etc/*-release; do
            OS_DISTRO+=$(< "$release_file")
        done

        if [[ -z $distro ]]; then
            OS_DISTRO=$KERNEL_VERSION
        fi
    fi
}

check_root() {
    # Make sure only root can run our script
    [[ $EUID -ne 0 ]] && echo -e "[${RED}Error${NONE}] This script must be run as root!" && exit 1
}

start() {
    clear

    get_os
    get_distro

    echo -e "\n-----------------------------------------------------------\n"
    echo -e " OS:           ${GREEN}$OS_NAME${NONE}"
    echo -e " Arch:         ${GREEN}$OS_ARCH${NONE}"
    echo -e " Distribution: ${GREEN}$OS_DISTRO${NONE}"
    echo -e "\n Start to initialize your os..."
    echo -e "\n-----------------------------------------------------------\n"
}

start
