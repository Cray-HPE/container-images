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
FROM ghcr.io/k8snetworkplumbingwg/multus-cni:v3.9.3 as base
# use thin entrypoint
FROM ghcr.io/k8snetworkplumbingwg/multus-cni:v4.0.1 as base-entrypoint

# Use distroless base image
FROM gcr.io/distroless/base-debian11:debug
WORKDIR /
# Copy necessary files from base
COPY --from=base /usr/src/multus-cni/bin /usr/src/multus-cni/bin
COPY --from=base-entrypoint /thin_entrypoint /thin_entrypoint

# Set the entrypoint
ENTRYPOINT ["/thin_entrypoint"]