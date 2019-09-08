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
    echo "permission 777 : $1"
    chmod 777 $1
}

# configurations
cmake_version=$1
if [ "" == "$cmake_version" ]; then
    add_broke_info "installation of cmake, no version specified"
else
    echo "##########################################################################################################"
    echo "# installing cmake-$cmake_version"
    echo "##########################################################################################################"
    for cmake_package in `ls cmake*${cmake_version}*.tar`
    do
        break
    done
    if [ "" == "$cmake_package" ]; then
        echo "[ERROR] cmake package not found (something like cmake*${cmake_version}*.tar)"
        add_broke_info_if_failed "cmake package not found (something like cmake*${cmake_version}*.tar)"
    else
        echo "using cmake package $cmake_package"
        tar xf $cmake_package
        add_broke_info_if_failed "extracting cmake package failed"
        cmake_dir=${cmake_package::`wc -c <<< $cmake_package`-5}
        for target in `ls $cmake_dir/bin/*`
        do
            x_permission $target
        done
        for target in `ls $cmake_dir/share/cmake-3.15/completions/*`
        do
            x_permission $target
        done
        cp -rf $cmake_dir/* /usr/
        rm -rf $cmake_dir
    fi
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

