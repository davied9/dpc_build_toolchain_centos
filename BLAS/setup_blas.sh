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
    echo "# something_broke = ${something_broke}"
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


for p__p in "procedure_helper" # fake a try block
do
    openblas=OpenBLAS-0.3.7
    openblas_package=${openblas}.tar
    openblas_dir=${openblas}
    echo "##########################################################################################################"
    echo "# installing ${openblas}"
    echo "##########################################################################################################"
    tar xf $openblas_package
    add_broke_info_if_failed "extracting $openblas package failed"
    cp -rf $openblas_dir/* /usr/
    rm -rf $openblas_dir
    if [ "" != "$something_broke" ]; then break; fi
done


# restore env
cd $bac_dir
rm -rf $working_dir

# exit
if [ "" != "${something_broke}" ]; then
    echo "$0 failed with following errors :"
    show_broke_info
    exit 1
else
    echo "$0 success"
    exit 0
fi


