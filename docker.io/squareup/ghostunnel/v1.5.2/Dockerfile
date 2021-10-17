FROM docker.io/squareup/ghostunnel:v1.5.2

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER 65534:65534
