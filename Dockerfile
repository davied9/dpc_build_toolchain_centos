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

# add develop user
RUN adduser --password aa31415926 --no-create-home --user-group developer \
    && mkdir /build_area \
    && chown developer.developer /build_area

USER developer
WORKDIR /build_area

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

