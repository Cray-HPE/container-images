#
# MIT License
#
# (C) Copyright [2022] Hewlett Packard Enterprise Development LP
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

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update; apt-get install -y --no-install-recommends ca-certificates curl netbase wget
RUN apt-get install -y --no-install-recommends gnupg dirmngr
RUN apt-get install -y --no-install-recommends git mercurial openssh-client subversion procps
RUN apt-get install -y --no-install-recommends autoconf automake bzip2 dpkg-dev file g++ gcc imagemagick libbz2-dev \
    libc6-dev libcurl4-openssl-dev libdb-dev libevent-dev libffi-dev libgdbm-dev libglib2.0-dev libgmp-dev libjpeg-dev libkrb5-dev liblzma-dev \
    libmagickcore-dev libmagickwand-dev libmaxminddb-dev libncurses5-dev libncursesw5-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev \
    libssl-dev libtool libwebp-dev  libxml2-dev libxslt-dev libyaml-dev make patch unzip xz-utils zlib1g-dev 
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=C.UTF-8
RUN apt-get install -y --no-install-recommends libbluetooth-dev tk-dev uuid-dev && rm -rf /var/lib/apt/lists/*
ENV GPG_KEY=E3FF2839C048B25C084DEBE9B26995E310250568
ENV PYTHON_VERSION=3.9.7
RUN wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"        \
    && wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc"        \
    && export GNUPGHOME="$(mktemp -d)"  \
    && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"   \
    && gpg --batch --verify python.tar.xz.asc python.tar.xz     \
    && { command -v gpgconf > /dev/null \
    && gpgconf --kill all || :; }       \
    && rm -rf "$GNUPGHOME" python.tar.xz.asc    \
    && mkdir -p /usr/src/python         \
    && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz   \
    && rm python.tar.xz                 \
    && cd /usr/src/python       \
    && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"        \
    && ./configure --build="$gnuArch" --enable-loadable-sqlite-extensions --enable-optimizations --enable-option-checking=fatal --enable-shared --with-system-expat --with-system-ffi --without-ensurepip \
    && make -j "$(nproc)"       \
    && make install \
    && rm -rf /usr/src/python \
    && find /usr/local -depth \( \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \) -exec rm -rf '{}' + \
    && ldconfig \
    && python3 --version
RUN cd /usr/local/bin \
    && ln -s idle3 idle         \
    && ln -s pydoc3 pydoc       \
    && ln -s python3 python     \
    && ln -s python3-config python-config
ENV PYTHON_PIP_VERSION=21.2.4
ENV PYTHON_SETUPTOOLS_VERSION=57.5.0
ENV PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/c20b0cfd643cd4a19246ccf204e2997af70f6b21/public/get-pip.py
RUN wget -O get-pip.py "$PYTHON_GET_PIP_URL" && python get-pip.py && rm -f get-pip.py

LABEL maintainer=unguiculus

RUN PHANTOMJS_VERSION=2.1.1 && \
    PHANTOMJS_PLATFORM=linux-x86_64 && \
    wget -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-${PHANTOMJS_PLATFORM}.tar.bz2 && \
    echo "86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f *phantomjs-${PHANTOMJS_VERSION}-${PHANTOMJS_PLATFORM}.tar.bz2" > phantomjs.sha256 && \
    sha256sum --check phantomjs.sha256 && \
    rm -f phantomjs.sha256 && \
    mkdir -p /usr/local/phantomjs-${PHANTOMJS_VERSION} && \
    tar -xjf phantomjs-${PHANTOMJS_VERSION}-${PHANTOMJS_PLATFORM}.tar.bz2 -C /usr/local/phantomjs-$PHANTOMJS_VERSION && \
    ln -s /usr/local/phantomjs-${PHANTOMJS_VERSION}/phantomjs-${PHANTOMJS_VERSION}-${PHANTOMJS_PLATFORM}/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -f phantomjs-${PHANTOMJS_VERSION}-${PHANTOMJS_PLATFORM}.tar.bz2 && \
    pip install selenium
RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y && \
    rm -rf /var/lib/apt/lists/ && \
    echo export OPENSSL_CONF=/etc/ssl/ >> /etc/bash.bashrc

