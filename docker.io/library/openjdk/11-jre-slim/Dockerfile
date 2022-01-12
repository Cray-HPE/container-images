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
RUN set -eux; apt-get update; apt-get install -y --no-install-recommends ca-certificates p11-kit ; rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/local/openjdk-11
RUN  { echo '#/bin/sh'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ] # backwards compatibility
ENV PATH=/usr/local/openjdk-11/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG=C.UTF-8
ENV JAVA_VERSION=11.0.12
RUN set -eux; arch="$(dpkg --print-architecture)"; case "$arch" in 'amd64') \
    downloadUrl='https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jre_x64_linux_11.0.12_7.tar.gz'; ;; 'arm64') \
    downloadUrl='https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jre_aarch64_linux_11.0.12_7.tar.gz'; ;; *) \
    echo >&2 "error: unsupported architecture: '$arch'"; exit 1 ;; esac; savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; apt-get install -y --no-install-recommends dirmngr gnupg wget ; rm -rf /var/lib/apt/lists/*; \
    wget --progress=dot:giga -O openjdk.tgz "$downloadUrl"; wget --progress=dot:giga -O openjdk.tgz.asc "$downloadUrl.sign"; export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys EAC843EBD3EFDB98CC772FADA5CD6035332FA671; \
    gpg --batch --keyserver keyserver.ubuntu.com --keyserver-options no-self-sigs-only --recv-keys CA5F11C6CE22644D42C6AC4492EF8D39DC13168F; \
    gpg --batch --list-sigs --keyid-format 0xLONG CA5F11C6CE22644D42C6AC4492EF8D39DC13168F | tee /dev/stderr | grep '0xA5CD6035332FA671' | grep 'Andrew Haley'; \
    gpg --batch --verify openjdk.tgz.asc openjdk.tgz; gpgconf --kill all; rm -rf "$GNUPGHOME"; mkdir -p "$JAVA_HOME";  tar --extract --file openjdk.tgz --directory "$JAVA_HOME" \
    --strip-components 1 --no-same-owner ; rm openjdk.tgz*; apt-mark auto '.*' > /dev/null; [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    { echo '#!/usr/bin/env bash'; echo 'set -Eeuo pipefail'; \
    echo 'trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose=server-auth "$JAVA_HOME/lib/security/cacerts"'; } > /etc/ca-certificates/update.d/docker-openjdk; \
    chmod +x /etc/ca-certificates/update.d/docker-openjdk;  /etc/ca-certificates/update.d/docker-openjdk; \
    find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf; ldconfig; java -Xshare:dump; java --version
RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/ 
