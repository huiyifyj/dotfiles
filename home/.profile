# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Remove comment and warning about java for deepin linux
# unset _JAVA_OPTIONS

# Application in /opt folder
# Authorize to non-root user by
#   $ sudo chown huiyifyj:huiyifyj -R /opt
APP=/opt

# Rust and cargo env
RUSTHOME=$HOME/.cargo
export PATH="$RUSTHOME/bin:$PATH"

# Go language ENV PATH
GOPATH=$HOME/go # go get download path
GOROOT=$APP/go
GOPROXY="https://goproxy.io"
export GOPATH GOROOT GOPROXY
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

# Lua env
LUAHOME=$APP/lua
export PATH="$LUAHOME/bin:$PATH"

# # JDK11 env variable
# export JAVA_HOME=$APP/jdk/jdk-11.0.2
# # JDK ENV SETTING
# export PATH="$JAVA_HOME/bin:$PATH"
export JAVA_HOME=$APP/jdk/jdk1.8.0_201
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

# Gradle ENV setting
GRADLE=$APP/gradle
export PATH="$GRADLE/bin:$PATH"

# Flutter ENV Setting
export FLUTTER=$APP/flutter
export PATH="$FLUTTER/bin:$PATH"
# Flutter setting.
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# Node and npm env
# NODE=$HOME/node
# NPM=$HOME/node/npm/bin
# export PATH=$NODE/bin:$NPM/bin:$PATH

# Node Version Manager, nvm ENV
export NVM_DIR="$APP/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Alias command
# View all active ports
alias ssp=ss -lntup
# View number of processes running per user
alias psu=ps hax -o user | sort | uniq -c | sort -hr
