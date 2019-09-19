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
    # install httpd24
    echo "##########################################################################################################"
    echo "# installing httpd24"
    echo "##########################################################################################################"
    i=0
    components[((i++))]=httpd24-runtime-1.1-5.el6.x86_64.rpm
    components[((i++))]=httpd24-libnghttp2-1.7.1-1.el6.x86_64.rpm
    components[((i++))]=httpd24-libcurl-7.47.1-1.1.el6.x86_64.rpm
    to_install=""
    for com in ${components[@]}
    do
        wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/httpd24/$com
        add_broke_info_if_failed "download of $com"
        if [ "" != "$something_broke" ]; then break; fi
        to_install="$to_install $com"
    done
    yum install -y $to_install
    add_broke_info_if_failed "installation of httpd24"
    yum clean packages && yum clean headers && yum clean metadata && yum clean all
    if [ "" != "$something_broke" ]; then break; fi
    
    # install git
    echo "##########################################################################################################"
    echo "# installing git-2.9"
    echo "##########################################################################################################"
    i=0
    components[((i++))]=rh-git29-runtime-2.3-4.el6.x86_64.rpm
    components[((i++))]=rh-git29-git-core-2.9.3-7.el6.x86_64.rpm
    components[((i++))]=rh-git29-git-core-doc-2.9.3-7.el6.x86_64.rpm
    components[((i++))]=rh-git29-perl-Git-2.9.3-7.el6.noarch.rpm
    components[((i++))]=rh-git29-git-2.9.3-7.el6.x86_64.rpm
    to_install=""
    for com in ${components[@]}
    do
        wget http://mirror.centos.org/centos/6/sclo/x86_64/rh/rh-git29/$com
        add_broke_info_if_failed "download of $com"
        if [ "" != "$something_broke" ]; then break; fi
        to_install="$to_install $com"
    done
    yum install -y $to_install
    add_broke_info_if_failed "installation of git-2.9"
    yum clean packages && yum clean headers && yum clean metadata && yum clean all
    if [ "" != "$something_broke" ]; then break; fi
    
    # install git-lfs
    echo "##########################################################################################################"
    echo "# installing git-lfs"
    echo "##########################################################################################################"
    wget https://github.com/git-lfs/git-lfs/releases/download/v2.8.0/git-lfs-linux-amd64-v2.8.0.tar.gz
    add_broke_info_if_failed "download of $com"
    if [ "" != "$something_broke" ]; then break; fi
    tar xf git-lfs-linux-amd64-v2.8.0.tar.gz
    cp -vf git-lfs /opt/rh/rh-git29/root/usr/bin/
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

