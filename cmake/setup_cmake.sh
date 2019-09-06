#!/bin/sh

# variables
bac_dir=`pwd`
working_dir=$(dirname $0)
cd $working_dir

# error info
something_broke=""
add_broke_info() {
    something_broke="${something_broke} $1;"
}
add_broke_info_if_failed() {
    if [ 0 != $? ]; then
        add_broke_info $1
    fi
}
show_broke_info() {
    local info_array
    echo "something_broke = ${something_broke}"
    IFS=";" read -ra info_array <<< "$something_broke"
    for i in "${info_array[@]}"
    do
        echo "  $i"
    done
}
x_permission() {
    echo "permission +x : $1"
    chmod +x $1
}

# configurations
cmake_version=$1
if [ "" == "$cmake_version" ]; then
    add_broke_info "installation of cmake, no version specified"
else
    echo "##########################################################################################################"
    echo "# installing cmake-$cmake_version"
    echo "##########################################################################################################"
    for cmake_package in `ls *.tar`
    do
        break
    done
    tar xf $cmake_package
    cmake_dir=${cmake_package::-4}
    for target in `ls $cmake_dir/bin/*`
    do
        x_permission $target
    done
    for target in `ls $cmake_dir/share/cmake-3.15/completions/*`
    do
        x_permission $target
    done
    mv -vf $cmake_dir/* /usr/
    rm -vr $cmake_dir
fi

# restore env
cd $bac_dir

# exit
if [ "" != "${something_broke}" ]; then
    echo "$0 failed with following errors :"
    show_broke_info
    exit 1
else
    echo "$0 success"
    exit 0
fi

