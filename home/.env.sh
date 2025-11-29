if [ -d "$DOTFILES_DIR" ]; then
    # append bin directory to $PATH
    export PATH="$DOTFILES_DIR/bin:$PATH"
fi

# Set default language and locale,
# more details to https://wiki.archlinux.org/title/Locale
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Set `vim` as default editor
export EDITOR="vim"

# Fix git error when gpgsign commit for Raspbian linux on raspberry pi
# https://stackoverflow.com/a/42265848
# If gnupg2 and gpg-agent 2.x are used, be sure to set the environment variable GPG_TTY.
# See https://www.gnupg.org/(it)/documentation/manuals/gnupg/Common-Problems.html
# export GPG_TTY=$(tty)

# Application in `$HOME/APP` folder
APP=$HOME/APP

# $APP/bin folder is used to store soft links pointing to executable files
export PATH="$APP/bin:$PATH"

# Go language env PATH
GOPATH=$HOME/.go # go get download path
GOROOT=$APP/go
GOPROXY="https://goproxy.cn,direct"
export GOPATH GOROOT GOPROXY
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
# Go setting for arm (for Raspbian on raspberry pi)
# GOOS=linux
# GOARCH=arm64
# export GOOS GOARCH
# Use private git server or internal network
# Refer to https://stackoverflow.com/a/38237165
# GOPRIVATE="git.fengyj.cn"
# GONOPROXY="git.fengyj.cn"
# GONOSUMDB="git.fengyj.cn"
# export GOPRIVATE GONOPROXY GONOSUMDB

# nvm, Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# Load nvm bash_completion for bash
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust custom installation directory
# Refer to https://github.com/rust-lang/rustup.rs/issues/618
RUSTUP_HOME=$HOME/.rust/rustup
CARGO_HOME=$HOME/.rust/cargo
export RUSTUP_HOME CARGO_HOME
# Cargo custom installation directory
# Refer to https://doc.rust-lang.org/cargo/commands/cargo-install.html
CARGO_INSTALL_ROOT=$HOME/.rust/cargo-install
export CARGO_INSTALL_ROOT
export PATH="$CARGO_HOME/bin:$CARGO_INSTALL_ROOT/bin:$PATH"

# Zig env setting
ZIG_HOME=$APP/zig
export PATH="$ZIG_HOME:$PATH"

# JDK env setting
# Recommend to use Adoptium Eclipse Temurin (formerly AdoptOpenJDK)
# Download from https://adoptium.net/temurin/releases
JAVA_HOME=$APP/java
export JAVA_HOME
export PATH=${JAVA_HOME}/bin:$PATH

# Gradle env setting
GRADLE_HOME=$APP/gradle
export PATH="$GRADLE_HOME/bin:$PATH"

# Flutter env Setting
export FLUTTER=$APP/flutter
export PATH="$FLUTTER/bin:$PATH"
# Flutter mirror setting
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
# export PUB_HOSTED_URL="https://mirrors.tuna.tsinghua.edu.cn/dart-pub"
# export FLUTTER_STORAGE_BASE_URL="https://mirrors.tuna.tsinghua.edu.cn/flutter"
