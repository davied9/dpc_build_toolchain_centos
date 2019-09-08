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
components="devtoolset-3-runtime-3.1-12.el6.x86_64.rpm;"
components+="devtoolset-3-binutils-2.24-18.el6.x86_64.rpm;"
# components+="devtoolset-3-binutils-devel-2.24-18.el6.x86_64.rpm;"
components+="devtoolset-3-libstdc++-devel-4.9.2-6.2.el6.x86_64.rpm;"
components+="devtoolset-3-gcc-4.9.2-6.2.el6.x86_64.rpm;"
components+="devtoolset-3-gcc-c++-4.9.2-6.2.el6.x86_64.rpm;"
# components+="devtoolset-3-gcc-gfortran-4.9.2-6.2.el6.x86_64.rpm;"
IFS=";" read -ra components <<< "$components"

echo "##########################################################################################################"
echo "# installing devtoolset-3"
echo "##########################################################################################################"
for com in ${components[@]}
do
    # download if neccessary
    if [ $DOWNLOAD_BEFORE_INSTALL == 1 ]; then
        com_url=http://mirror.centos.org/centos/6/sclo/x86_64/rh/devtoolset-3/$com
        echo "downloading component $com from $com_url"
        curl $com_url --output $com
        result=$?
        if [ 0 != $result ]; then
            echo "[ERROR] failed installing of $1 with code $result ..."
            add_broke_info "installation of $1, code $result"
            break
        fi
    fi
    # install if pre-downloaded or downloaded successfully
    if ! [ -f $com ]; then
        echo "[ERROR] $1 not exist ..."
        add_broke_info "installation of $1, package not exist"
        break
    fi
    echo "installing component $com"
    yum install -y $com
    result=$?
    rm -vf $com
    if [ 0 != $result ]; then
        echo "[ERROR] failed installing of $1 with code $result ..."
        add_broke_info "installation of $1, code $result"
        break
    fi
    # cleanup for each package installation
    yum clean packages && yum clean headers && yum clean metadata && yum clean all
done


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

