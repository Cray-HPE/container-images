FROM docker.io/bats/bats:v1.1.0

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER 65534:65534
