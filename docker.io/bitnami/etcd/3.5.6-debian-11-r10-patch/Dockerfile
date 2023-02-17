#
# MIT License
#
# (C) Copyright [2023] Hewlett Packard Enterprise Development LP
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
FROM docker.io/bitnami/etcd:3.5.6-debian-11-r10
USER root

#
# These can be removed once we push fixes upstream:
#
# 1. libetcd.sh can be removed when we change that file
#    to honor ETCD_SNAPSHOT_DIR.
#
# 2. snapshot.sh can be removed when chart to allows ETCD_SNAPSHOT_DIR to
#    be passed into the Cronjob.
#
COPY ./resources/libetcd.sh /opt/bitnami/scripts/libetcd.sh
COPY ./resources/snapshot.sh /opt/bitnami/scripts/etcd/snapshot.sh

#
# 3. The chown below can be removed once we push a fix
#    upstream to update the volume-permissions init container
#    to chown multiple dirs (not just /bitnami/etcd).
#
RUN chown -R 1001:1001 /opt/bitnami && apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/

USER 1001
