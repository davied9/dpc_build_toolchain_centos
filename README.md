# dpc_build_toolchain_centos
dpc_build_toolchain_centos

# Environment matrix

 * Linux-3.10.0-957.el7.x86_64-x86_64-with-centos-6.8-Final
 * Python : 2.6.6
 * CMake : 3.15.2
 * GNU Make : 3.81
 * GCC : 4.9.2 20150212 (Red Hat 4.9.2-6)
 * CC : 4.9.2 20150212 (Red Hat 4.9.2-6)
 * g++ : 4.9.2 20150212 (Red Hat 4.9.2-6)
 * c++ : 4.9.2 20150212 (Red Hat 4.9.2-6)
 * Ninja : 1.9.0
 
devtoolset-3 is packed

# How to install

build with 
```
docker build -t dpc_build_toolchain_centos:dev
```
or install with
```
docker pull davied9/dpc_build_toolchain_centos:latest
```

# More

https://cloud.docker.com/repository/docker/davied9/dpc_build_toolchain_centos
