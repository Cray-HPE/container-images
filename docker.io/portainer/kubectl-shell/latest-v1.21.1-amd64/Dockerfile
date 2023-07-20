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
FROM docker.io/portainer/kubectl-shell:latest-v1.21.1-amd64

USER 0
RUN apk add --upgrade apk-tools --no-cache && apk update --no-cache && apk --update-cache upgrade --no-cache && apk add --no-cache rpm2cpio cpio && rm -rf /var/cache/apk/*
# use curl to download the rpm file
RUN curl -L https://github.com/Cray-HPE/cray-site-init/releases/download/v1.32.0/cray-site-init-1.32.0-1.x86_64.noos.rpm -o /tmp/cray-site-init.rpm
RUN cd /tmp && rpm2cpio cray-site-init.rpm | cpio -idmv && cp /tmp/usr/bin/csi /usr/local/bin/csi && rm -rf /tmp
USER 1000
