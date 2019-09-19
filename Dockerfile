FROM centos:6.8

USER root

# install wget
RUN yum install -y wget unzip dos2unix unix2dos \
    && yum clean packages && yum clean headers && yum clean metadata && yum clean all

# install devtoolset-3
COPY ./devtoolset-3/* /tmp/devtoolset-3/
RUN sh /tmp/devtoolset-3/setup_devtoolset-3.sh

# install cmake
COPY ./cmake/* /tmp/cmake/
RUN sh /tmp/cmake/setup_cmake.sh 3.15.2

# install git && git-lfs
COPY ./git/* /tmp/git/
RUN sh /tmp/git/setup_git.sh

# install git
RUN yum install -y git git-lfs \
    && yum clean packages \
    && yum clean headers \
    && yum clean metadata \
    && yum clean all

# install needed python packages
COPY ./python/* /tmp/python/
RUN sh /tmp/python/setup_python.sh

# install ninja
COPY ./ninja/ninja /usr/bin/ninja
RUN chmod 777 /usr/bin/ninja

# setup entrypoint
COPY ./scripts/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 777 /usr/bin/entrypoint.sh

WORKDIR /home

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

