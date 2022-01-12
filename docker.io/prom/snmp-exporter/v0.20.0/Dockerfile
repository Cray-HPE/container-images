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
FROM golang:1-alpine AS build

ARG VERSION="0.20.0"
ARG CHECKSUM="4326749fb36b829ca43e9d60fc09f43b62788f353c491aa3367705d52b96fae9"

ADD https://github.com/prometheus/snmp_exporter/archive/v$VERSION.tar.gz /tmp/snmp_exporter.tar.gz

RUN [ "$(sha256sum /tmp/snmp_exporter.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
    apk add curl make && \
    tar -C /tmp -xf /tmp/snmp_exporter.tar.gz && \
    mkdir -p /go/src/github.com/prometheus && \
    mv /tmp/snmp_exporter-$VERSION /go/src/github.com/prometheus/snmp_exporter && \
    cd /go/src/github.com/prometheus/snmp_exporter && \
      make build

RUN mkdir -p /rootfs && \
      cp /go/src/github.com/prometheus/snmp_exporter/snmp.yml /rootfs/ && \
    mkdir -p /rootfs/bin && \
      cp /go/src/github.com/prometheus/snmp_exporter/snmp_exporter /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd


FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
EXPOSE 9116/tcp
ENTRYPOINT ["/bin/snmp_exporter"]
