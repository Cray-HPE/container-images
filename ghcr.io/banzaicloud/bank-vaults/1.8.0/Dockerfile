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
