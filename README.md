# dpc_build_toolchain_centos
dpc_build_toolchain_centos



# Environment matrix

| Tool     | Version |
|:--------:|:-------------------:|
| system   | Linux-3.10.0-957.el7.x86_64-x86_64-with-centos-6.8-Final |
| Python   | 2.6.6 |
| CMake    | 3.15.2 |
| GNU Make | 3.81 |
| GCC      | 4.9.2 20150212 (Red Hat 4.9.2-6) |
| CC       | 4.9.2 20150212 (Red Hat 4.9.2-6) |
| g++      | 4.9.2 20150212 (Red Hat 4.9.2-6) |
| c++      | 4.9.2 20150212 (Red Hat 4.9.2-6) |
| Ninja    | 1.9.0 |
| Git      | 1.7.1 |
 
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

# An example

```
git clone https://github.com/davied9/simple_cpp_program.git
cd simple_cpp_program
python -m build -D -I davied9/dpc_build_toolchain_centos:latest install
./packages/simple_cpp_program
```

or

```
git clone https://github.com/davied9/simple_cpp_program.git
docker run --rm -t \
    --mount type=bind,source=`pwd`/simple_cpp_program,target=/home \
   davied9/dpc_build_toolchain_centos:latest \
   bash -c "mkdir /home/build && cd /home/build && cmake .. && make install && cd /home && ./packages/simple_cpp_program"
```

if the following message is printed, then test is passed

```
Hello from ./packages/simple_cpp_program
```

# More

https://cloud.docker.com/repository/docker/davied9/dpc_build_toolchain_centos
