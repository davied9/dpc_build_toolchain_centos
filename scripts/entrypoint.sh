#!/bin/sh

source /opt/rh/devtoolset-3/enable

if [ "" == "$1" ]; then
    # if no command given, show environment configurations
    echo "checking environment ...."
    check_tool() {
        which $1
        $1 --version
        echo ""
    }
    check_tool gcc
    check_tool cmake
    check_tool ninja
else
    # execute the command if any specified
    exec "$@"
fi
