from ubuntu:19.04 as builder

RUN apt-get update \
    &&  apt-get -y install git clang cmake make gcc g++ libmariadbclient-dev \
        libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev \
        mariadb-server p7zip libmariadb-client-lgpl-dev-compat \
    && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100

RUN mkdir /TrinityCore
RUN git clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore.git /Trinity
RUN mkdir -p /Trinity/build && cd /Trinity/build && cmake ../ -DCMAKE_INSTALL_PREFIX=/TrinityCore && make && make -j $(nproc) install
FROM ubuntu:19.04
RUN apt-get update \
    && apt-get -y install libmariadb3 libboost-system1.67 libboost-filesystem1.67 \
       libboost-thread1.67 libboost-program-options1.67 libboost-iostreams1.67 libssl1.1\
       libreadline8 \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /TrinityCore /TrinityCore
WORKDIR /TrinityCore

