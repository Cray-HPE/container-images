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
FROM ghcr.io/banzaicloud/bank-vaults:1.8.0 as upstream

FROM artifactory.algol60.net/docker.io/library/alpine

RUN apk update && \
    apk add --upgrade --no-cache \
        apk-tools \
        ca-certificates \
        curl \
        ccid \
        opensc \
        pcsc-lite-libs \
        softhsm && \
    apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER 65534

# Initializing SoftHSM to be able to create a working example (only for dev),
# sharing the HSM device is emulated with a pre-created keypair in the image.
RUN softhsm2-util --init-token --free --label bank-vaults --so-pin banzai --pin banzai
RUN pkcs11-tool --module /usr/lib/softhsm/libsofthsm2.so --keypairgen --key-type rsa:2048 --pin banzai --token-label bank-vaults --label bank-vaults

COPY --from=upstream /usr/local/bin/template /usr/local/bin/template
COPY --from=upstream /usr/local/bin/bank-vaults /usr/local/bin/bank-vaults
COPY --from=upstream /usr/local/bin/pcscd-entrypoint.sh /usr/local/bin/pcscd-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/bank-vaults"]
