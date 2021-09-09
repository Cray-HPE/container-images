#!/bin/bash -e

git clone https://github.com/kubernetes/node-problem-detector.git
cd node-problem-detector
ENABLE_JOURNALD=0 PLATFORMS=linux_amd64 make build-binaries
