FROM docker.io/library/redis:5.0-alpine3.12

RUN apk update && \
    apk add --upgrade apk-tools &&  \
    apk -U upgrade && \
    rm -rf /var/cache/apk/*
