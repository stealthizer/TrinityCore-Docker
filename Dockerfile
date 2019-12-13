from ubuntu:19.04 as builder

RUN apt-get update && apt-get -y install git clang cmake make gcc g++ libmariadbclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev \
  mariadb-server p7zip libmariadb-client-lgpl-dev-compat && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100

RUN mkdir /TrinityCore
RUN git clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore.git /Trinity
RUN mkdir -p /Trinity/build && cd /Trinity/build && cmake ../ -DCMAKE_INSTALL_PREFIX=/TrinityCore && make && make -j $(nproc) install
FROM alpine
COPY --from=builder /TrinityCore /TrinityCore
WORKDIR /TrinityCore

