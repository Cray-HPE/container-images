FROM docker.io/library/postgres:13.2-alpine

RUN apk update && \
    apk add --upgrade apk-tools &&  \
    apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER 65534:65534
