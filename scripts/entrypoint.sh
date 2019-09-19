#!/bin/sh

# add user path for python executable
export PATH=$HOME/.local/bin:$PATH

# enable devtoolset-3 && git 2.9 && httpd24
source /opt/rh/devtoolset-3/enable
source /opt/rh/rh-git29/enable
source /opt/rh/httpd24/enable

if [ "" == "$1" ]; then
    # if no command given, show environment configurations
    echo "checking environment ...."
    check_tool() {
        which $1
        $1 --version
        echo ""
    }
    check_tool gcc
    check_tool g++
    check_tool cmake
    check_tool ninja
    check_tool python
    check_tool git
    check_tool git-lfs
else
    # execute the command if any specified
    exec "$@"
fi
