FROM ghcr.io/banzaicloud/bank-vaults:1.8.0

USER root

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER nobody