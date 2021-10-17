FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt-get install -y wget build-essential libtool autoconf automake pkg-config unzip libkrb5-dev

RUN cd /tmp && wget http://download.zeromq.org/zeromq-4.0.5.tar.gz && \
    tar xzvf zeromq-4.0.5.tar.gz && cd /tmp/zeromq-4.0.5 && ./configure -prefix=/usr && \
    make && make install && ldconfig

RUN cd /tmp && wget https://github.com/jedisct1/libsodium/archive/1.0.0.zip && unzip 1.0.0.zip && \
    cd libsodium-1.0.0 && ./autogen.sh && ./configure --prefix=/usr && \
    make check && make install && ldconfig

RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y \
    && rm -rf /var/lib/apt/lists/

USER 65534:65534
