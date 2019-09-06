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

# configurations
DOWNLOAD_BEFORE_INSTALL=1

# download && install devtoolset-3
if [ $DOWNLOAD_BEFORE_INSTALL == 1 ]; then
    wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/devtoolset-3/devtoolset-3-runtime-3.1-12.el6.x86_64.rpm
    wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/devtoolset-3/devtoolset-3-binutils-2.24-18.el6.x86_64.rpm
    #wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/devtoolset-3/devtoolset-3-binutils-devel-2.24-18.el6.x86_64.rpm
    wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/devtoolset-3/devtoolset-3-libstdc++-devel-4.9.2-6.2.el6.x86_64.rpm
    wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/devtoolset-3/devtoolset-3-gcc-4.9.2-6.2.el6.x86_64.rpm
    wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/devtoolset-3/devtoolset-3-gcc-c++-4.9.2-6.2.el6.x86_64.rpm
    #wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/devtoolset-3/devtoolset-3-gcc-gfortran-4.9.2-6.2.el6.x86_64.rpm
fi
install_if_exist() {
    if [ -f $1 ]; then
        yum install -y $1
        local result=$?
        if [ 0 != $result ]; then
            echo "[ERROR] failed installing of $1 ..."
            add_broke_info "installation of $1"
            return $result
        fi
        return 0
    else
        echo "[ERROR] $1 not exist ..."
        add_broke_info "installation of $1"
        return 1
    fi
}

echo "##########################################################################################################"
echo "# installing devtoolset-3"
echo "##########################################################################################################"
install_if_exist devtoolset-3-runtime-3.1-12.el6.x86_64.rpm
install_if_exist devtoolset-3-binutils-2.24-18.el6.x86_64.rpm
install_if_exist devtoolset-3-libstdc++-devel-4.9.2-6.2.el6.x86_64.rpm
install_if_exist devtoolset-3-gcc-4.9.2-6.2.el6.x86_64.rpm
install_if_exist devtoolset-3-gcc-c++-4.9.2-6.2.el6.x86_64.rpm

# cleanup
yum clean packages
yum clean headers
yum clean metadata
yum clean all

# restore env
cd $bac_dir
# rm -rf $working_dir

# exit
if [ "" != "${something_broke}" ]; then
    echo "$0 failed with following errors :"
    show_broke_info
    exit 1
else
    echo "$0 success"
    exit 0
fi

