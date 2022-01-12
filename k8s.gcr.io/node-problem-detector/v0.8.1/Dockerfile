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
FROM k8s.gcr.io/node-problem-detector:v0.8.1 as upstream

FROM golang:1.17-buster as builder
RUN git clone https://github.com/kubernetes/node-problem-detector.git /opt/node-problem-detector\
    && cd /opt/node-problem-detector\
    && git checkout v0.8.1\
    && ENABLE_JOURNALD=0 make vet fmt version test build-binaries

FROM docker.io/ubuntu:20.04
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
COPY --from=builder /opt/node-problem-detector/bin/node-problem-detector /
COPY --from=upstream /home/kubernetes /home/kubernetes
COPY --from=upstream /config /config
ENTRYPOINT ["/node-problem-detector","--system-log-monitors=/config/kernel-monitor.json"]
