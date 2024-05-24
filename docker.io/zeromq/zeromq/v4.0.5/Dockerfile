#
# MIT License
#
# (C) Copyright 2022-2024 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt-get install -y wget build-essential libtool autoconf automake pkg-config unzip libkrb5-dev \
    && ln -s /usr/bin/libtoolize /usr/bin/libtool

RUN cd /tmp && wget https://github.com/jedisct1/libsodium/archive/1.0.0.zip && unzip 1.0.0.zip && \
    cd libsodium-1.0.0 && ./autogen.sh && ./configure --prefix=/usr && \
    make check && make install && ldconfig && rm -Rf 1.0.0.zip libsodium-1.0.0

RUN cd /tmp && wget -O libzmq-4.0.5.tar.gz https://github.com/zeromq/libzmq/archive/refs/tags/v4.0.5.tar.gz && \
    tar xzvf libzmq-4.0.5.tar.gz && cd /tmp/libzmq-4.0.5 && ./autogen.sh && ./configure -prefix=/usr && \
    make && make install && ldconfig && rm -Rf libzmq-4.0.5.tar.gz libzmq-4.0.5

RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y \
    && rm -rf /var/lib/apt/lists/
