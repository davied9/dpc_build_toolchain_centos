FROM centos:6.8

USER root

# configurations
ARG ninja_version=1.9.0
ARG cmake_version=3.15.2

# install devtoolset-3
COPY ./devtoolset-3/* /tmp/devtoolset-3/
RUN sh /tmp/devtoolset-3/setup_devtoolset-3.sh

# install cmake
COPY ./cmake/* /tmp/cmake/
RUN sh /tmp/cmake/setup_cmake.sh ${cmake_version}

# install git
RUN yum install -y git git-lfs \
    && yum clean packages \
    && yum clean headers \
    && yum clean metadata \
    && yum clean all

# install needed python packages
RUN yum install -y python-argparse \
    && yum clean packages \
    && yum clean headers \
    && yum clean metadata \
    && yum clean all

# install ninja
COPY ./ninja/ninja-${ninja_version} /usr/bin/ninja
RUN chmod 777 /usr/bin/ninja

# setup entrypoint
COPY ./scripts/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod 777 /usr/bin/entrypoint.sh

WORKDIR /home

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

